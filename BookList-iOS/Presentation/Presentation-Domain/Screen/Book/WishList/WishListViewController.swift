import UIKit

final class WishListViewController: UIViewController {

    private let router: RouterProtocol = Router()

    private var viewModel: WishListViewModel!
    private var dataSource: WishListDataSource!

    @IBOutlet weak var tableView: UITableView!

    static func createInstance(viewModel: WishListViewModel) -> WishListViewController {
        let instance = WishListViewController.instantiateInitialViewController()
        instance.viewModel = viewModel
        return instance
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupTableView()
        sendScreenView()
    }
}

extension WishListViewController {

    private func setupNavigation() {
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: .blank,
            style: .plain,
            target: nil,
            action: nil
        )
    }

    private func setupTableView() {
        dataSource = WishListDataSource(viewModel: viewModel)
        tableView.register(WishListTableViewCell.xib(), forCellReuseIdentifier: WishListTableViewCell.resourceName)
        tableView.tableFooterView = UIView()
        tableView.dataSource = dataSource
        tableView.delegate = self
        tableView.rowHeight = 150
    }

    func reloadWishList(book: BookViewData) {
        viewModel.updateBook(book: book)
        tableView.reloadData()
    }
}

extension WishListViewController: UITableViewDelegate {

    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard let book = viewModel.books.any(at: indexPath.row) else {
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
                successHandler: reloadWishList
            ),
            from: self
        )
    }
}

extension WishListViewController: NavigationBarConfiguration {
    var navigationTitle: String? { Resources.Strings.App.wishList }
}

extension WishListViewController: AnalyticsConfiguration {
    var screenName: AnalyticsScreenName? { .wishlist }
}
