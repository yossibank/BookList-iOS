import UIKit

final class BookListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    static func createInstance() -> BookListViewController {
        BookListViewController.instantiateInitialViewController()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension BookListViewController {

    private func setupTableView() {
        tableView.register(BookListTableViewCell.xib(), forCellReuseIdentifier: BookListTableViewCell.resourceName)
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension BookListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension BookListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: BookListTableViewCell.resourceName,
            for: indexPath
        ) as? BookListTableViewCell ?? BookListTableViewCell()

        return cell
    }
}
