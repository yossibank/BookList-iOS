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
                let usecase = SignupUsecase()
                let viewModel = SignupViewModel(usecase: usecase)
                let vc = SignupViewController.createInstance(viewModel: viewModel)
                return vc
            }

            func login() -> LoginViewController {
                let viewModel = LoginViewModel()
                let vc = LoginViewController.createInstance(viewModel: viewModel)
                return vc
            }
        }
    }
}
