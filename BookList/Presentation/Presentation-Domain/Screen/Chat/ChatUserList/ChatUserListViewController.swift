import UIKit
import RxSwift
import RxCocoa

final class ChatUserListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    private let router: RouterProtocol = Router()
    private let disposeBag: DisposeBag = DisposeBag()

    private var viewModel: ChatUserListViewModel!
    private var dataSource: ChatUserListDataSource!
    private var selectedUser: FirestoreUser?

    static func createInstance(viewModel: ChatUserListViewModel) -> ChatUserListViewController {
        let instance = ChatUserListViewController.instantiateInitialViewController()
        instance.viewModel = viewModel
        return instance
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItem()
        setupTableView()
        viewModel.fetchUsers()
        bindViewModel()
    }

    private func setupNavigationItem() {
        navigationItem.rightBarButtonItem?.isEnabled = false
        navigationItem.rightBarButtonItem?.rx.tap.subscribe { [weak self] _ in
            guard
                let self = self,
                let user = self.selectedUser
            else {
                return
            }

            FirestoreManager.shared.createRoom(partnerUser: user)
            self.router.dismiss(self, animated: true)

        }.disposed(by: disposeBag)
    }

    private func setupTableView() {
        dataSource = ChatUserListDataSource()
        tableView.register(ChatUserListTableViewCell.xib(), forCellReuseIdentifier: ChatUserListTableViewCell.resourceName)
        tableView.tableFooterView = UIView()
        tableView.dataSource = dataSource
        tableView.delegate = self
        tableView.rowHeight = 80
    }
}

extension ChatUserListViewController {

    private func bindViewModel() {
        viewModel.userList
            .asDriver(onErrorJustReturn: [])
            .drive(onNext: { [weak self] users in
                guard let self = self else { return }

                self.dataSource.chatUserList = users
                self.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
}

extension ChatUserListViewController: UITableViewDelegate {

    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        navigationItem.rightBarButtonItem?.isEnabled = true

        if let user = dataSource.chatUserList.any(at: indexPath.row) {
            selectedUser = user
        }
    }

    func tableView(
        _ tableView: UITableView,
        didDeselectRowAt indexPath: IndexPath
    ) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
}

extension ChatUserListViewController: NavigationBarConfiguration {

    var navigationTitle: String? {
        Resources.Strings.App.selectUser
    }

    var rightBarButton: [NavigationBarButton] {
        [.startTalk]
    }
}
