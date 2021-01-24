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
                let viewModel = HomeViewModel()
                let vc = HomeViewController.createInstance(viewModel: viewModel)
                return vc
            }
            
            func bookList() -> BookListViewController {
                let usecase = BookListUsecase()
                let viewModel = BookListViewModel(usecase: usecase)
                let vc = BookListViewController.createInstance(viewModel: viewModel)
                return vc
            }

            func addBook() -> AddBookViewController {
                let viewModel = AddBookViewModel()
                let vc = AddBookViewController.createInstance(viewModel: viewModel)
                return vc
            }

            func editBook(bookId: Int, bookData: EditBookViewData) -> EditBookViewController {
                let usecase = EditBookUsecase(bookId: bookId)
                let viewModel = EditBookViewModel(usecase: usecase, bookData: bookData)
                let vc = EditBookViewController.createInstance(viewModel: viewModel)
                return vc
            }

            func wishList() -> WishListViewController {
                let vc = WishListViewController.createInstance()
                return vc
            }
        }
    }
}
