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
        tableView.contentInset = .init(top: 60, left: 0, bottom: 0, right: 0)
        tableView.scrollIndicatorInsets = .init(top: 60, left: 0, bottom: 0, right: 0)
        tableView.keyboardDismissMode = .interactive
        tableView.transform = .init(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: 0)
    }

    private func fetchChatMessages() {
        viewModel.fetchChatMessages { [weak self] documentChange, chatMessage in
            guard let self = self else { return }

            switch documentChange.type {

            case .added:
                self.dataSource.chatMessages.insert(chatMessage, at: 0)
                self.dataSource.chatMessages.sort { $0.sendAt.dateValue() > $1.sendAt.dateValue() }

            case .modified, .removed: break

            }

            DispatchQueue.main.async {
                self.tableView.reloadData()
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
