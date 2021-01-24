import UIKit

final class WishListViewController: UIViewController {

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

}
