import UIKit

extension Resources {

    static var ViewControllers: ViewController {
        ViewController()
    }

    struct ViewController {

        var App: AppControllers {
            AppControllers()
        }

        struct AppControllers {

            func signup() -> SignupViewController {
                let vc = SignupViewController.createInstance()
                return vc
            }

            func login() -> LoginViewController {
                let vc = LoginViewController.createInstance()
                return vc
            }
        }
    }
}
