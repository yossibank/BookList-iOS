import UIKit

final class ChatUserListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func setupTableView() {
        tableView.register(ChatUserListTableViewCell.xib(), forCellReuseIdentifier: ChatUserListTableViewCell.resourceName)
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 80
    }
}

extension ChatUserListViewController: UITableViewDelegate {
    
}

extension ChatUserListViewController: UITableViewDataSource {

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        10
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: ChatUserListTableViewCell.resourceName,
            for: indexPath
        )

        if let chatUserListCell = cell as? ChatUserListViewController {
            
        }

        return cell
    }
}
