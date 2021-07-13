import UIKit

final class ChatSelectViewController: UIViewController {

    @IBOutlet var tableView: UITableView!

    static func createInstance() -> ChatSelectViewController {
        let instance = ChatSelectViewController.instantiateInitialViewController()
        return instance
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }

    private func setupTableView() {
        tableView.register(
            ChatSelectTableViewCell.xib(),
            forCellReuseIdentifier: ChatSelectTableViewCell.resourceName
        )
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 100
    }
}

extension ChatSelectViewController: UITableViewDelegate {}

extension ChatSelectViewController: UITableViewDataSource {

    func tableView(
        _: UITableView,
        numberOfRowsInSection _: Int
    ) -> Int {
        10
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: ChatSelectTableViewCell.resourceName,
            for: indexPath
        )

        if let chatSelectCell = cell as? ChatSelectTableViewCell {}

        return cell
    }
}
