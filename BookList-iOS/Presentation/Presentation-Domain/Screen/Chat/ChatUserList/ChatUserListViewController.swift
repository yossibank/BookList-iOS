import UIKit

final class ChatUserListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    private let router: RouterProtocol = Router()

    static func createInstance() -> ChatUserListViewController {
        let instance = ChatUserListViewController.instantiateInitialViewController()
        return instance
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }

    private func setupTableView() {
        tableView.register(ChatUserListTableViewCell.xib(), forCellReuseIdentifier: ChatUserListTableViewCell.resourceName)
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.rowHeight = 80
    }
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

extension ChatUserListViewController: NavigationBarConfiguration {

    var navigationTitle: String? {
        Resources.Strings.App.talkList
    }
}
