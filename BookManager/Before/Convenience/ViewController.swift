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

//            func login() -> LoginViewController {
//                let usecase = LoginUsecase()
//                let viewModel = LoginViewModel(usecase: usecase)
//                let vc = LoginViewController.createInstance(viewModel: viewModel)
//                return vc
//            }

            func home() -> HomeViewController {
                let usecase = HomeUsecase()
                let viewModel = HomeViewModel(usecase: usecase)
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
                let usecase = AddBookUsecase()
                let viewModel = AddBookViewModel(usecase: usecase)
                let vc = AddBookViewController.createInstance(viewModel: viewModel)
                return vc
            }

            func editBook(
                bookId: Int,
                bookViewData: BookViewData,
                successHandler: ((BookViewData) -> Void)?
            ) -> EditBookViewController {
                let usecase = EditBookUsecase(bookId: bookId)
                let viewModel = EditBookViewModel(usecase: usecase)
                let vc = EditBookViewController.createInstance(
                    viewModel: viewModel,
                    bookViewData: bookViewData,
                    successHandler: successHandler
                )
                return vc
            }

            func wishList() -> WishListViewController {
                let viewModel = WishListViewModel()
                let vc = WishListViewController.createInstance(viewModel: viewModel)
                return vc
            }

            func chatSelect() -> ChatSelectViewController {
                let viewModel = ChatSelectViewModel()
                let vc = ChatSelectViewController.createInstance(viewModel: viewModel)
                return vc
            }

            func chatUserList() -> ChatUserListViewController {
                let usecase = ChatUserListUsecase()
                let viewModel = ChatUserListViewModel(usecase: usecase)
                let vc = ChatUserListViewController.createInstance(viewModel: viewModel)
                return vc
            }

            func chatRoom(roomId: String, user: FirestoreUser) -> ChatRoomViewController {
                let viewModel = ChatRoomViewModel(roomId: roomId, user: user)
                let vc = ChatRoomViewController.createInstance(viewModel: viewModel)
                return vc
            }
        }
    }
}
