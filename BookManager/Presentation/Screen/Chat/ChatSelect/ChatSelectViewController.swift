import Combine
import CombineCocoa
import UIKit

extension ChatSelectViewController: VCInjectable {
    typealias R = ChatSelectRouting
    typealias VM = ChatSelectViewModel
}

// MARK: - properties

final class ChatSelectViewController: UIViewController {
    var routing: R! { didSet { routing.viewController = self } }
    var viewModel: VM!

    private let tableView: UITableView = .init(
        frame: .zero
    )

    private var dataSource: ChatSelectDataSource!
    private var cancellables: Set<AnyCancellable> = []

    deinit {
        viewModel.removeListener()
    }
}

// MARK: - override methods

extension ChatSelectViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupLayout()
        setupTableView()
        setupEvent()
        fetchRooms()
    }
}

// MARK: - private methods

extension ChatSelectViewController {

    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(tableView)
    }

    private func setupLayout() {
        tableView.layout {
            $0.top == view.topAnchor
            $0.bottom == view.bottomAnchor
            $0.leading == view.leadingAnchor
            $0.trailing == view.trailingAnchor
        }
    }

    private func setupTableView() {
        dataSource = ChatSelectDataSource()
        tableView.dataSource = dataSource

        tableView.register(
            ChatSelectTableViewCell.xib(),
            forCellReuseIdentifier: ChatSelectTableViewCell.resourceName
        )
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.rowHeight = 80
    }

    private func setupEvent() {
        navigationItem.rightBarButtonItem?.tapPublisher
            .sink { [weak self] in
                self?.routing.showChatUserListScreen()
            }
            .store(in: &cancellables)
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

// MARK: - Delegate

extension ChatSelectViewController: UITableViewDelegate {

    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)

        if let room = dataSource.roomList.any(at: indexPath.row) {
            let roomId = room.users.map { String($0.id) }.joined()

            viewModel.findUser { [weak self] _ in
                guard let self = self else { return }

                self.routing.showChatRoomScreen()
            }
        }
    }
}

// MARK: - Protocol

extension ChatSelectViewController: NavigationBarConfiguration {

    var navigationTitle: String? {
        Resources.Strings.Navigation.Title.talkList
    }

    var rightBarButton: [NavigationBarButton] {
        [.addUser]
    }
}
