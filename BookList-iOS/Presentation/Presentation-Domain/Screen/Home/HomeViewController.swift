import UIKit
import RxSwift
import RxCocoa

final class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    private let router: RouterProtocol = Router()
    private let disposeBag: DisposeBag = DisposeBag()

    private var viewModel: HomeViewModel!
    private var dataSource: HomeDataSource!

    static func createInstance(viewModel: HomeViewModel) -> HomeViewController {
        let instance = HomeViewController.instantiateInitialViewController()
        instance.viewModel = viewModel
        return instance
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupTableView()
        bindViewModel()
    }
}

extension HomeViewController {

    private func setupNavigation() {
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(logoutButtonTapped)
        )
        tapGesture.numberOfTapsRequired = 1
        navigationItem.rightBarButtonItem?.customView?.addGestureRecognizer(tapGesture)
    }

    private func setupTableView() {
        dataSource = HomeDataSource()
        tableView.register(HomeTableViewCell.xib(), forCellReuseIdentifier: HomeTableViewCell.resourceName)
        tableView.tableFooterView = UIView()
        tableView.dataSource = dataSource
        tableView.delegate = self
        tableView.rowHeight = 100
    }

    @objc private func logoutButtonTapped() {
        showActionAlert(
            title: Resources.Strings.App.logout,
            message: Resources.Strings.Alert.didYouLogout)
        { [weak self] in
            self?.viewModel.logout()
        }
    }
}

extension HomeViewController {

    private func bindViewModel() {
        viewModel.result
            .asDriver(onErrorJustReturn: nil)
            .drive(onNext: { [weak self] result in
                guard let self = self,
                      let result = result else { return }

                switch result {

                case .success:
                    let window = UIApplication.shared.windows.first { $0.isKeyWindow }
                    window?.rootViewController = self.router.initialWindow(.login, type: .normal)

                case .failure(let error):
                    if let error = error as? APIError {
                        dump(error.description())
                    }
                    self.showError(
                        title: Resources.Strings.General.error,
                        message: Resources.Strings.Alert.failedLogout
                    )
                }
            })
            .disposed(by: disposeBag)
    }
}

extension HomeViewController: UITableViewDelegate {

    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)

        let route = HomeViewData.HomeItem.allCases.map { $0.routes }[indexPath.row]
        router.push(route, from: self)
    }
}

extension HomeViewController: NavigationBarConfiguration {

    var navigationTitle: String? {
        Resources.Strings.App.home
    }

    var rightBarButton: [NavigationBarButton] {
        [.logout]
    }
}
