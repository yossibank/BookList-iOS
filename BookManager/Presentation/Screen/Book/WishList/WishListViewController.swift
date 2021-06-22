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
    var routing: R! { didSet { routing.viewController = self } }
    var viewModel: VM!

    private let tableView: UITableView = .init(frame: .zero)

    private var cancellables: Set<AnyCancellable> = []
    private var dataSource: WishListDataSource!
}

// MARK: - override methods

extension WishListViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupLayout()
        setupTableView()
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

    func setupView() {
        view.backgroundColor = .white
        view.addSubview(tableView)
    }

    func setupLayout() {
        tableView.layout {
            $0.top == view.topAnchor
            $0.bottom == view.bottomAnchor
            $0.leading == view.leadingAnchor
            $0.trailing == view.trailingAnchor
        }
    }

    func setupTableView() {
        dataSource = WishListDataSource(viewModel: viewModel)

        tableView.register(
            WishListTableViewCell.xib(),
            forCellReuseIdentifier: WishListTableViewCell.resourceName
        )
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

        guard
            let book = viewModel.books.any(at: indexPath.row)
        else {
            return
        }

        routing.showEditBookScreen(id: book.id)
    }
}

// MARK: - Protocol

extension WishListViewController: NavigationBarConfiguration {

    var navigationTitle: String? {
        Resources.Strings.Navigation.Title.wishList
    }
}
