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
    private var footerView: UIView = .init()

    static func createInstance(viewModel: BookListViewModel) -> BookListViewController {
        let instance = BookListViewController.instantiateInitialViewController()
        instance.viewModel = viewModel
        return instance
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupTableView()
        bindViewModel()
    }
}

extension BookListViewController {
    
    private func setupNavigation() {
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: .blank,
            style: .plain,
            target: nil,
            action: nil
        )
    }

    private func setupTableView() {
        dataSource = BookListDataSource(viewModel: viewModel)

        tableView.register(BookListTableViewCell.xib(), forCellReuseIdentifier: BookListTableViewCell.resourceName)
        tableView.dataSource = dataSource
        tableView.delegate = self
        tableView.rowHeight = 150

        footerView.frame = .init(x: 0, y: 0, width: view.frame.width, height: 44)
        tableView.tableFooterView = footerView
    }

    func reloadBookList() {
        viewModel.resetBookData()
        viewModel.fetchBookList(isInitial: true)
    }
}

extension BookListViewController {

    private func bindViewModel() {
        viewModel.fetchBookList(isInitial: true)

        viewModel.result
            .asDriver(onErrorJustReturn: nil)
            .drive(onNext: { [weak self] result in
                guard let self = self,
                      let result = result else { return }

                switch result {

                case .success(let response):
                    dump(response)
                    self.tableView.reloadData()

                case .failure(let error):
                    if let error = error as? APIError {
                        dump(error.description())
                    }
                    self.showError(
                        title: Resources.Strings.General.error,
                        message: Resources.Strings.Alert.failedBookList
                    )
                }
            })
            .disposed(by: disposeBag)

        viewModel.loading
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] loading in
                guard let self = self else { return }

                loading ?
                    self.loadingIndicator.startAnimating() :
                    self.loadingIndicator.stopAnimating()

                self.footerView.isHidden = loading ? false : true
            })
            .disposed(by: disposeBag)
    }
}

extension BookListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard let bookId = viewModel.getBookId(index: indexPath.row),
              let book = viewModel.books.any(at: indexPath.row)
        else {
            return
        }

        let bookData = EditBookViewData(
            name: book.name,
            image: book.image,
            price: book.price,
            purchaseDate: book.purchaseDate
        )

        router.push(.editBook(bookId: bookId, bookData: bookData), from: self)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastSection = tableView.numberOfSections - 1
        let lastIndex = tableView.numberOfRows(inSection: lastSection) - 1

        if indexPath.section == lastSection && indexPath.row == lastIndex {
            viewModel.fetchBookList(isInitial: false)
        }
    }
}
