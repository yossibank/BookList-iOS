import UIKit

final class AccountRouting: Routing {
    weak var viewController: UIViewController?
}

extension AccountRouting {

    func showLoginScreen() {
        let loginVC = Resources.ViewControllers.App.login()
        let window = UIApplication.shared.windows.first { $0.isKeyWindow }
        window?.rootViewController = loginVC
    }
}
