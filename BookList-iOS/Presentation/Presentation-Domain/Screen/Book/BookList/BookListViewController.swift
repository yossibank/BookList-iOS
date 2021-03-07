import UIKit
import RxSwift
import RxCocoa

final class BookListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!

    private let router: RouterProtocol = Router()
    private let disposeBag: DisposeBag = DisposeBag()

    private var viewModel: BookListViewModel!
    private var dataSource: BookListDataSource!

    static func createInstance(viewModel: BookListViewModel) -> BookListViewController {
        let instance = BookListViewController.instantiateInitialViewController()
        instance.viewModel = viewModel
        return instance
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        viewModel.fetchBookList(isInitial: true)
        bindViewModel()
        sendScreenView()
    }
}

extension BookListViewController {

    private func setupTableView() {
        dataSource = BookListDataSource()
        dataSource.delegate = self
        tableView.register(BookListTableViewCell.xib(), forCellReuseIdentifier: BookListTableViewCell.resourceName)
        tableView.tableFooterView = UIView()
        tableView.dataSource = dataSource
        tableView.delegate = self
        tableView.rowHeight = 150
    }

    func updateBookList(book: BookViewData) {
        dataSource.updateCellDataList(book: book)
        tableView.reloadData()
    }
}

extension BookListViewController {

    private func bindViewModel() {

        viewModel.bookList
            .asDriver(onErrorJustReturn: [])
            .drive(onNext: { [weak self] bookList in
                guard let self = self else { return }

                self.dataSource.cellDataList.append(contentsOf: bookList ?? [])
                self.tableView.reloadData()
            })
            .disposed(by: disposeBag)

        viewModel.loading
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] loading in
                guard let self = self else { return }

                loading ?
                    self.loadingIndicator.startAnimating()
                    : self.loadingIndicator.stopAnimating()
            })
            .disposed(by: disposeBag)

        viewModel.error
            .asDriver(onErrorJustReturn: nil)
            .drive(onNext: { [weak self] error in
                guard let self = self else { return }

                if let error = error {
                    if let apiError = error as? APIError {
                        dump(apiError.description())
                    }

                    self.showError(
                        title: Resources.Strings.General.error,
                        message: Resources.Strings.Alert.failedBookList
                    ) {
                        self.router.dismiss(self, animated: true)
                    }
                }
            })
            .disposed(by: disposeBag)
    }
}

extension BookListViewController: UITableViewDelegate {

    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard
            let book = dataSource.cellDataList.any(at: indexPath.row)
        else {
            return
        }

        let bookData = BookViewData(
            id: book.id,
            name: book.name,
            image: book.image,
            price: book.price,
            purchaseDate: book.purchaseDate,
            isFavorite: book.isFavorite
        )

        router.push(
            .editBook(
                bookId: book.id,
                bookData: bookData,
                successHandler: updateBookList
            ),
            from: self
        )
    }

    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        let lastSection = tableView.numberOfSections - 1
        let lastIndex = tableView.numberOfRows(inSection: lastSection) - 1

        if indexPath.section == lastSection && indexPath.row == lastIndex {
            viewModel.fetchBookList(isInitial: false)
        }
    }
}

extension BookListViewController: BookListDataSourceDelegate {

    func didSelectFavoriteButton(index: Int) {
        guard
            let book = dataSource.cellDataList.any(at: index)
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

extension BookListViewController: NavigationBarConfiguration {

    var navigationTitle: String? {
        Resources.Strings.App.bookList
    }
}

extension BookListViewController: AnalyticsConfiguration {

    var screenName: AnalyticsScreenName? {
        .booklist
    }
}
