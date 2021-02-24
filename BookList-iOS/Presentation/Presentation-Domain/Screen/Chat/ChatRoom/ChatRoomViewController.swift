import UIKit

final class ChatRoomViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    static func createInstance() -> ChatRoomViewController {
        let instance = ChatRoomViewController.instantiateInitialViewController()
        return instance
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }

    private func setupTableView() {
        tableView.register(OtherMessageTableViewCell.xib(), forCellReuseIdentifier: OtherMessageTableViewCell.resourceName)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
    }
}

extension ChatRoomViewController: UITableViewDelegate {

}

extension ChatRoomViewController: UITableViewDataSource {

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
            withIdentifier: OtherMessageTableViewCell.resourceName,
            for: indexPath
        )

        if let chatRoomCell = cell as? OtherMessageTableViewCell {
            chatRoomCell.backgroundColor = .clear
        }

        return cell
    }
}
