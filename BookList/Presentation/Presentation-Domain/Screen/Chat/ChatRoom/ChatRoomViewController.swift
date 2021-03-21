import UIKit

final class ChatRoomViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    private var viewModel: ChatRoomViewModel!
    private var dataSource: ChatRoomDataSource!

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

    deinit {
        viewModel.removeListener()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        fetchChatMessages()
    }

    override var inputAccessoryView: UIView? {
        keyboardAccessoryView
    }

    override var canBecomeFirstResponder: Bool {
        true
    }

    private func setupTableView() {
        dataSource = ChatRoomDataSource(viewModel: viewModel)
        tableView.register(MyMessageTableViewCell.xib(), forCellReuseIdentifier: MyMessageTableViewCell.resourceName)
        tableView.register(OtherMessageTableViewCell.xib(), forCellReuseIdentifier: OtherMessageTableViewCell.resourceName)
        tableView.dataSource = dataSource
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        tableView.contentInset = .init(top: 0, left: 0, bottom: 60, right: 0)
        tableView.scrollIndicatorInsets = .init(top: 0, left: 0, bottom: 60, right: 0)
    }

    private func fetchChatMessages() {
        viewModel.fetchChatMessages { [weak self] documentChange, chatMessage in
            guard let self = self else { return }

            switch documentChange.type {

            case .added:
                self.dataSource.chatMessages.append(chatMessage)
                self.dataSource.chatMessages.sort { $0.sendAt.dateValue() < $1.sendAt.dateValue() }

            case .modified, .removed: break

            }

            DispatchQueue.main.async {
                let lastMessageCell = self.dataSource.chatMessages.count - 1
                self.tableView.reloadData()
                self.tableView.scrollToRow(
                    at: IndexPath(row: lastMessageCell, section: 0),
                    at: .bottom,
                    animated: true
                )
            }
        }
    }
}

extension ChatRoomViewController: KeyboardAccessoryViewDelegate {

    func didTappedSendButton(message: String) {
        keyboardAccessoryView.didSendText()
        viewModel.sendChatMessage(message: message)
    }
}
