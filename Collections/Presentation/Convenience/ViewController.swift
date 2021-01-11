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
                let usecase = LoginUsecase()
                let viewModel = LoginViewModel(usecase: usecase)
                let vc = LoginViewController.createInstance(viewModel: viewModel)
                return vc
            }

            func home() -> HomeViewController {
                let vc = HomeViewController.createInstance()
                return vc
            }
            
            func bookList() -> BookListViewController {
                let viewModel = BookListViewModel()
                let vc = BookListViewController.createInstance(viewModel: viewModel)
                return vc
            }
        }
    }
}
