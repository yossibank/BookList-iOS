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
                let vc = SignupViewController()
                vc.inject(routing: SignupRouting(), viewModel: SignupViewModel())
                return vc
            }

            func login() -> LoginViewController {
                let vc = LoginViewController()
                vc.inject(routing: LoginRouting(), viewModel: LoginViewModel())
                return vc
            }

            func bookList() -> BookListViewController {
                let vc = BookListViewController()
                vc.inject(routing: BookListRouting(), viewModel: BookListViewModel())
                return vc
            }

            func addBook() -> AddBookViewController {
                let vc = AddBookViewController()
                vc.inject(routing: NoRouting(), viewModel: AddBookViewModel())
                return vc
            }

            func editBook(id: Int) -> EditBookViewController {
                let vc = EditBookViewController.instantiateInitialViewController()
                vc.inject(routing: NoRouting(), viewModel: EditBookViewModel(id: id))
                return vc
            }

            func wishList() -> WishListViewController {
                let vc = WishListViewController.instantiateInitialViewController()
                vc.inject(routing: WishListRouting(), viewModel: WishListViewModel())
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
