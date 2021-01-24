import UIKit

final class WishListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    static func createInstance() -> WishListViewController {
        WishListViewController.instantiateInitialViewController()
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
        tableView.register(WishListTableViewCell.xib(), forCellReuseIdentifier: WishListTableViewCell.resourceName)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 150
    }
}

extension WishListViewController: UITableViewDelegate {

}

extension WishListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell()
    }
}
