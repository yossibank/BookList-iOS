import UIKit

final class SignupRouting: Routing {
    weak var viewController: UIViewController?
}

extension SignupRouting {

    func showLoginScreen() {
        let loginVC = Resources.ViewControllers.App.login()

        if viewController?.presentingViewController is LoginViewController {
            viewController?.dismiss(animated: true)
        } else {
            viewController?.present(loginVC, animated: true)
        }
    }

    func showRootScreen() {
        let tabVC = RootTabBarController()
        let window = UIApplication.shared.windows.first { $0.isKeyWindow }
        window?.rootViewController = tabVC
    }

    func dismiss() {
        viewController?.dismiss(animated: true)
    }
}
