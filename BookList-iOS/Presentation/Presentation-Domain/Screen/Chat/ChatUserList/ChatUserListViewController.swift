import UIKit
import RxSwift
import RxCocoa

final class ChatUserListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    private var users: [FirestoreUser] = []

    private let router: RouterProtocol = Router()
    private let disposeBag: DisposeBag = DisposeBag()

    private var viewModel: ChatUserListViewModel!

    static func createInstance(viewModel: ChatUserListViewModel) -> ChatUserListViewController {
        let instance = ChatUserListViewController.instantiateInitialViewController()
        instance.viewModel = viewModel
        return instance
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        viewModel.fetchUsers()
        bindViewModel()
    }

    private func setupTableView() {
        tableView.register(ChatUserListTableViewCell.xib(), forCellReuseIdentifier: ChatUserListTableViewCell.resourceName)
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.rowHeight = 80
    }
}

extension ChatUserListViewController {

    private func bindViewModel() {
        viewModel.userList
            .asDriver(onErrorJustReturn: [])
            .drive(onNext: { [weak self] users in
                guard let self = self else { return }

                self.users = users
                self.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
}

extension ChatUserListViewController: UITableViewDataSource {

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        users.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: ChatUserListTableViewCell.resourceName,
            for: indexPath
        )

        if let chatUserListCell = cell as? ChatUserListTableViewCell {
            if let user = users.any(at: indexPath.row) {
                chatUserListCell.setup(user: user)
            }
        }

        return cell
    }
}

extension ChatUserListViewController: NavigationBarConfiguration {

    var navigationTitle: String? {
        Resources.Strings.App.talkList
    }
}
