import UIKit

final class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    private let router: RouterProtocol = Router()
    private let homeItems = CellItem.allCases.compactMap { $0.rawValue }

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
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension HomeViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension HomeViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
                withIdentifier: HomeTableViewCell.resourceName,
                for: indexPath
        ) as? HomeTableViewCell ?? HomeTableViewCell()

        cell.setup(item: homeItems[indexPath.row])
        return cell
    }
}
