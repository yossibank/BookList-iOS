import UIKit

final class LoginRouting: Routing {
    weak var viewController: UIViewController?
}

extension LoginRouting {

    func showSignupScreen() {
        let signupVC = SignupViewController.instantiateInitialViewController()
        signupVC.inject(routing: SignupRouting(), viewModel: SignupViewModel())

        if viewController?.presentingViewController is SignupViewController {
            viewController?.dismiss(animated: true)
        } else {
            viewController?.present(signupVC, animated: true)
        }
    }

    func showHomeScreen() {
        let bookListVC = BookListViewController.instantiateInitialViewController()
        bookListVC.inject(routing: BookListRouting(), viewModel: BookListViewModel())

        let nc = MainNavigationController(rootViewController: bookListVC)
        nc.setupNavigationBar(
            forVC: bookListVC,
            config: bookListVC as NavigationBarConfiguration
        )

        let window = UIApplication.shared.windows.first { $0.isKeyWindow }
        window?.rootViewController = nc
    }
}
