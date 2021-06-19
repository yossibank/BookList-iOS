import UIKit
import RxSwift
import RxCocoa

final class ChatSelectViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    private let router: RouterProtocol = Router()
    private let disposeBag: DisposeBag = DisposeBag()

    private var viewModel: ChatSelectViewModel!
    private var dataSource: ChatSelectDataSource!

    static func createInstance(viewModel: ChatSelectViewModel) -> ChatSelectViewController {
        let instance = ChatSelectViewController.instantiateInitialViewController()
        instance.viewModel = viewModel
        return instance
    }

    deinit {
        viewModel.removeListener()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupButton()
        setupTableView()
        fetchRooms()
    }

    private func setupButton() {
        navigationItem.rightBarButtonItem?.rx.tap.subscribe { [weak self] _ in
            guard let self = self else { return }

            self.router.present(.chatUserList, from: self, isModalInPresentation: false)
        }.disposed(by: disposeBag)
    }

    private func setupTableView() {
        dataSource = ChatSelectDataSource()
        tableView.register(ChatSelectTableViewCell.xib(), forCellReuseIdentifier: ChatSelectTableViewCell.resourceName)
        tableView.tableFooterView = UIView()
        tableView.dataSource = dataSource
        tableView.delegate = self
        tableView.rowHeight = 80
    }

    private func fetchRooms() {
        viewModel.fetchRooms { [weak self] documentChange, room in
            guard let self = self else { return }

            switch documentChange.type {

            case .added:
                self.dataSource.roomList.append(room)

            case .removed:
                self.dataSource.roomList = self.dataSource.roomList.filter { $0.id != room.id }

            case .modified:
                self.dataSource.roomList = []
                self.dataSource.roomList.append(room)

            }

            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

extension ChatSelectViewController: UITableViewDelegate {

    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)

        if let room = dataSource.roomList.any(at: indexPath.row) {
            let roomId = room.users.map { String($0.id) }.joined()

            viewModel.findUser { [weak self] user in
                guard let self = self else { return }

                self.router.push(.chatRoom(roomId: roomId, user: user), from: self)
            }
        }
    }
}

extension ChatSelectViewController: NavigationBarConfiguration {

    var navigationTitle: String? {
        Resources.Strings.Navigation.Title.talkList
    }

    var rightBarButton: [NavigationBarButton] {
        [.addUser]
    }
}
