import Combine
import CombineCocoa
import UIKit
import Utility

extension BookListViewController: VCInjectable {
    typealias R = BookListRouting
    typealias VM = BookListViewModel
}

// MARK: - properties

final class BookListViewController: UIViewController {
    var routing: R! { didSet { self.routing.viewController = self } }
    var viewModel: VM!

    private var dataSource: BookListDataSource!
    private var cancellables: Set<AnyCancellable> = []

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
}

// MARK: - override methods

extension BookListViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchBookList()
        setupTableView()
        setupButton()
        bindViewModel()
        sendScreenView()
    }
}

// MARK: - internal methods

extension BookListViewController {

    func updateBookList(book: BookViewData) {
        dataSource.updateCellDataList(book: book)
        tableView.reloadData()
    }
}


// MARK: private methods

private extension BookListViewController {

    func setupTableView() {
        dataSource = BookListDataSource(viewModel: viewModel)
        dataSource.delegate = self
        tableView.register(
            BookListTableViewCell.xib(),
            forCellReuseIdentifier: BookListTableViewCell.resourceName
        )
        tableView.tableFooterView = UIView()
        tableView.dataSource = dataSource
        tableView.delegate = self
        tableView.rowHeight = 150
    }

    func setupButton() {
        navigationItem.rightBarButtonItem?.tapPublisher
            .sink { [weak self] in
                self?.routing.showAddBookScreen()
            }
            .store(in: &cancellables)
    }

    func bindViewModel() {
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                switch state {
                case .standby:
                    self?.loadingIndicator.stopAnimating()

                case .loading:
                    self?.loadingIndicator.startAnimating()

                case .done:
                    self?.loadingIndicator.stopAnimating()
                    self?.tableView.reloadData()

                case .failed:
                    self?.loadingIndicator.stopAnimating()
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - Delegate

extension BookListViewController: UITableViewDelegate {

    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard
            let book = viewModel.bookList.any(at: indexPath.row)
        else {
            return
        }

        self.routing.showEditBookScreen(id: book.id)
    }

    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        let lastSection = tableView.numberOfSections - 1
        let lastIndex = tableView.numberOfRows(inSection: lastSection) - 1

        if indexPath.section == lastSection && indexPath.row == lastIndex {
            viewModel.fetchBookList()
        }
    }
}

extension BookListViewController: BookListDataSourceDelegate {

    func didSelectFavoriteButton(index: Int) {
        guard
            let book = viewModel.bookList.any(at: index)
        else {
            return
        }

        if book.isFavorite {
            viewModel.removeFavoriteBook(book: book)
        } else {
            viewModel.saveFavoriteBook(book: book)
        }

        dataSource.updateFavorite(index: index, bookViewData: book)
        tableView.reloadRows(
            at: [IndexPath(row: index, section: 0)],
            with: .fade
        )
    }
}

// MARK: - Protocol

extension BookListViewController: NavigationBarConfiguration {

    var navigationTitle: String? {
        Resources.Strings.Navigation.Title.bookList
    }

    var rightBarButton: [NavigationBarButton] {
        [.addBook]
    }
}

extension BookListViewController: AnalyticsConfiguration {

    var screenName: AnalyticsScreenName? {
        .booklist
    }
}
