import UIKit

final class ChatRoomViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    private var viewModel: ChatRoomViewModel!

    private lazy var keyboardAccessoryView: KeyboardAccessoryView = {
        let view = KeyboardAccessoryView()
        view.frame = .init(x: 0, y: 0, width: view.frame.width, height: 50)
        view.delegate = self
        return view
    }()

    static func createInstance(viewModel: ChatRoomViewModel) -> ChatRoomViewController {
        let instance = ChatRoomViewController.instantiateInitialViewController()
        instance.viewModel = viewModel
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
        viewModel.messages.count
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
            chatRoomCell.userMessageTextView.text = viewModel.messages[indexPath.row]
        }

        return cell
    }
}

extension ChatRoomViewController: KeyboardAccessoryViewDelegate {

    func didTappedSendButton(message: String) {
        keyboardAccessoryView.didSendText()
        viewModel.messages.append(message)
        viewModel.sendChatMessage(message: message)
        tableView.reloadData()
    }
}
