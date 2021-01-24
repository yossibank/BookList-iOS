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
        tableView.dataSource = dataSource
        tableView.delegate = self
        tableView.rowHeight = 150
    }
}

extension WishListViewController: UITableViewDelegate {

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
}
