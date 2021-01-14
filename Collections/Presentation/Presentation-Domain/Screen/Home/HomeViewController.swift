import UIKit

final class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    private let router: RouterProtocol = Router()

    private var dataSource: HomeDataSource! = HomeDataSource()

    static func createInstance() -> HomeViewController {
        HomeViewController.instantiateInitialViewController()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
}

extension HomeViewController {

    private func setupTableView() {
        tableView.register(HomeTableViewCell.xib(), forCellReuseIdentifier: HomeTableViewCell.resourceName)
        tableView.dataSource = dataSource
        tableView.rowHeight = 100
    }
}
