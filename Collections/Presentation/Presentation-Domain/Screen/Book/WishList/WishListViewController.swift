import UIKit

final class WishListViewController: UIViewController {
    
    private var viewModel: WishListViewModel!

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
        viewModel.books.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: WishListTableViewCell.resourceName,
            for: indexPath
        )

        if let wishListCell = cell as? WishListTableViewCell {
            wishListCell.accessoryType = .disclosureIndicator
            wishListCell.bookImageView.image = nil
            wishListCell.setup(book: viewModel.books[indexPath.row])
        }
        
        return cell
    }
}
