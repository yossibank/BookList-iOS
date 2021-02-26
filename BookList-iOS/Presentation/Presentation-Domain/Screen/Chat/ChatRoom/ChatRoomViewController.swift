import UIKit

final class ChatRoomViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    private var keyboardAccessoryView: KeyboardAccessoryView = {
        let view = KeyboardAccessoryView()
        view.frame = .init(x: 0, y: 0, width: view.frame.width, height: 80)
        return view
    }()

    static func createInstance() -> ChatRoomViewController {
        let instance = ChatRoomViewController.instantiateInitialViewController()
        return instance
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }

    override var inputAccessoryView: UIView? {
        keyboardAccessoryView
    }

    override var canBecomeFirstResponder: Bool {
        true
    }

    private func setupTableView() {
        tableView.register(MyMessageTableViewCell.xib(), forCellReuseIdentifier: MyMessageTableViewCell.resourceName)
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
            withIdentifier: MyMessageTableViewCell.resourceName,
            for: indexPath
        )

        if let chatRoomCell = cell as? MyMessageTableViewCell {
            chatRoomCell.backgroundColor = .clear
        }

        return cell
    }
}
