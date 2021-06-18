import UIKit

final class SignupRouting: Routing {
    weak var viewController: UIViewController?
}

extension SignupRouting {

    func showLoginScreen() {
        let loginVC = LoginViewController.instantiateInitialViewController()
        loginVC.inject(routing: LoginRouting(), viewModel: LoginViewModel())

        if viewController?.presentingViewController is LoginViewController {
            viewController?.dismiss(animated: true)
        } else {
            viewController?.present(loginVC, animated: true)
        }
    }

    func showHomeScreen() {
        
    }
}
