import UIKit
import RxSwift
import RxCocoa

final class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    private let router: RouterProtocol = Router()
    private let disposeBag: DisposeBag = DisposeBag()

    private var viewModel: HomeViewModel!
    private var dataSource: HomeDataSource! = HomeDataSource()

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
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: .blank,
            style: .plain,
            target: nil,
            action: nil
        )
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: Resources.Images.General.logout?.withRenderingMode(.alwaysOriginal),
            style: .plain,
            target: self,
            action: #selector(tappedLogoutButton)
        )
    }

    private func setupTableView() {
        tableView.register(HomeTableViewCell.xib(), forCellReuseIdentifier: HomeTableViewCell.resourceName)
        tableView.dataSource = dataSource
        tableView.delegate = self
        tableView.rowHeight = 100
    }

    @objc private func tappedLogoutButton() {
        showAlert(
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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let routes = HomeCellData.HomeItem.allCases.compactMap { $0.routes }
        router.push(routes[indexPath.row], from: self)
    }
}
