import UIKit
import RxSwift
import RxCocoa

final class ChatSelectViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    private let router: RouterProtocol = Router()
    private let disposeBag: DisposeBag = DisposeBag()

    static func createInstance() -> ChatSelectViewController {
        let instance = ChatSelectViewController.instantiateInitialViewController()
        return instance
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupButton()
        setupTableView()
    }

    private func setupButton() {
        navigationItem.rightBarButtonItem?.rx.tap.subscribe { [weak self] _ in
            guard let self = self else { return }

            self.router.present(.chatUserList, from: self, isModalInPresentation: false)
        }.disposed(by: disposeBag)
    }

    private func setupTableView() {
        tableView.register(ChatSelectTableViewCell.xib(), forCellReuseIdentifier: ChatSelectTableViewCell.resourceName)
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 80
    }
}

extension ChatSelectViewController: UITableViewDelegate {

    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)
        router.push(.chatRoom, from: self)
    }
}

extension ChatSelectViewController: UITableViewDataSource {

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
            withIdentifier: ChatSelectTableViewCell.resourceName,
            for: indexPath
        )

        if let chatSelectCell = cell as? ChatSelectTableViewCell {
            
        }

        return cell
    }
}

extension ChatSelectViewController: NavigationBarConfiguration {

    var navigationTitle: String? {
        Resources.Strings.App.talkList
    }

    var rightBarButton: [NavigationBarButton] {
        [.addUser]
    }
}
