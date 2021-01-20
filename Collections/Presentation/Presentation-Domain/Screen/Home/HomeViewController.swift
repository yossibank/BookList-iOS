import UIKit

final class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    private let router: RouterProtocol = Router()

    private var viewModel: HomeViewModel!
    private var dataSource: HomeDataSource! = HomeDataSource()

    static func createInstance(viewModel: HomeViewModel) -> HomeViewController {
        let instance = HomeViewController.instantiateInitialViewController()
        instance.viewModel = viewModel
        return instance
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupTableView()
    }
}

extension HomeViewController {

    private func setupNavigation() {
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: .blank,
            style: .plain,
            target: nil,
            action: nil
        )
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: Resources.Images.General.logout?.withRenderingMode(.alwaysOriginal),
            style: .plain,
            target: self,
            action: #selector(tappedLogoutButton)
        )
    }

    private func setupTableView() {
        tableView.register(HomeTableViewCell.xib(), forCellReuseIdentifier: HomeTableViewCell.resourceName)
        tableView.dataSource = dataSource
        tableView.delegate = self
        tableView.rowHeight = 100
    }
    
    @objc private func tappedLogoutButton() {
        
    }
}

extension HomeViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let routes = HomeCellData.HomeItem.allCases.compactMap { $0.routes }
        router.push(routes[indexPath.row], from: self)
    }
}
