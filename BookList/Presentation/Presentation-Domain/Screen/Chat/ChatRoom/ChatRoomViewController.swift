import UIKit

final class ChatRoomViewController: UIViewController {

    private struct Constants {
        static let accessoryHeight: CGFloat = 100
        static let contentInset: UIEdgeInsets = .init(top: 60, left: 0, bottom: 0, right: 0)
    }

    @IBOutlet weak var tableView: UITableView!

    private var viewModel: ChatRoomViewModel!
    private var dataSource: ChatRoomDataSource!
    private var safeAreaBottom: CGFloat {
        self.view.safeAreaInsets.bottom
    }

    private lazy var keyboardAccessoryView: KeyboardAccessoryView = {
        let view = KeyboardAccessoryView()
        view.frame = .init(x: 0, y: 0, width: view.frame.width, height: Constants.accessoryHeight)
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
        setupNotification()
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
        tableView.contentInset = Constants.contentInset
        tableView.scrollIndicatorInsets = Constants.contentInset
        tableView.transform = .init(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: 0)
        tableView.keyboardDismissMode = .onDrag
    }

    private func setupNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
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

    @objc private func keyboardWillShow(notification: NSNotification) {
        if let endFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            guard endFrame.height >= Constants.accessoryHeight else { return }

            let top = endFrame.height - safeAreaBottom
            let contentInset = UIEdgeInsets(top: top, left: 0, bottom: 0, right: 0)

            tableView.contentInset = contentInset
            tableView.scrollIndicatorInsets = contentInset
            tableView.contentOffset = .init(x: 0, y: -top)
        }
    }

    @objc private func keyboardWillHide() {
        tableView.contentInset = Constants.contentInset
        tableView.scrollIndicatorInsets = Constants.contentInset
    }
}

extension ChatRoomViewController: KeyboardAccessoryViewDelegate {

    func didTappedSendButton(message: String) {
        keyboardAccessoryView.didSendText()
        viewModel.sendChatMessage(message: message)
    }
}
