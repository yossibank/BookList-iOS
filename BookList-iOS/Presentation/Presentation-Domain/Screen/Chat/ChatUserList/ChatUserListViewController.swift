import UIKit
import RxSwift
import RxCocoa

final class ChatUserListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    private let router: RouterProtocol = Router()
    private let disposeBag: DisposeBag = DisposeBag()

    private var viewModel: ChatUserListViewModel!
    private var dataSource: ChatUserListDataSource!

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
        dataSource = ChatUserListDataSource()
        tableView.register(ChatUserListTableViewCell.xib(), forCellReuseIdentifier: ChatUserListTableViewCell.resourceName)
        tableView.tableFooterView = UIView()
        tableView.dataSource = dataSource
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

extension ChatUserListViewController: NavigationBarConfiguration {

    var navigationTitle: String? {
        Resources.Strings.App.talkList
    }
}
