import Combine
import CombineCocoa
import UIKit
import Utility

extension WishListViewController: VCInjectable {
    typealias R = WishListRouting
    typealias VM = WishListViewModel
}

// MARK: - properties

final class WishListViewController: UIViewController {
    var routing: R!
    var viewModel: VM!

    private var cancellables: Set<AnyCancellable> = []
    private var dataSource: WishListDataSource!

    @IBOutlet weak var tableView: UITableView!
}

// MARK: - override methods

extension WishListViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        sendScreenView()
    }
}

// MARK: - internal methods

extension WishListViewController {

    func reloadWishList(book: BookViewData) {
        viewModel.updateBook(book: book)
        tableView.reloadData()
    }
}

// MARK: - private methods

private extension WishListViewController {

    func setupTableView() {
        dataSource = WishListDataSource(viewModel: viewModel)
        tableView.register(WishListTableViewCell.xib(), forCellReuseIdentifier: WishListTableViewCell.resourceName)
        tableView.tableFooterView = UIView()
        tableView.dataSource = dataSource
        tableView.delegate = self
        tableView.rowHeight = 150
    }
}

// MARK: - Delegate

extension WishListViewController: UITableViewDelegate {

    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard let book = viewModel.books.any(at: indexPath.row) else {
            return
        }

        routing.showEditBookScreen(id: book.id)
    }
}

// MARK: - Protocol

extension WishListViewController: NavigationBarConfiguration {

    var navigationTitle: String? {
        Resources.Strings.App.wishList
    }
}

extension WishListViewController: AnalyticsConfiguration {

    var screenName: AnalyticsScreenName? {
        .wishlist
    }
}
