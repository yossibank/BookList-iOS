import UIKit

extension RootTabBarController: VCInjectable {
    typealias R = NoRouting
    typealias VM = NoViewModel
}

// MARK: - properties

final class RootTabBarController: UITabBarController {
    var routing: R!
    var viewModel: VM!
}

// MARK: - override methods

extension RootTabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setViewControllers(Tabs.allCases.map { $0.viewControllers }, animated: false)
    }
}

enum Tabs: Int, CaseIterable {
    case bookList
    case wishList
    case chatList

    private var title: String {
        switch self {
        case .bookList:
            return Resources.Strings.TabBar.bookList

        case .wishList:
            return Resources.Strings.TabBar.wishList

        case .chatList:
            return Resources.Strings.TabBar.chat
        }
    }

    private var image: UIImage? {
        switch self {
        case .bookList:
            return Resources.Images.TabBar.bookList

        case .wishList:
            return Resources.Images.TabBar.wishList

        case .chatList:
            return Resources.Images.TabBar.chat
        }
    }

    private var tabBarItem: UITabBarItem {
        .init(title: title, image: image, tag: self.rawValue)
    }

    private var baseViewController: UIViewController {
        let viewController: UIViewController

        switch self {
        case .bookList:
            let bookListVC = BookListViewController.instantiateInitialViewController()
            bookListVC.inject(routing: BookListRouting(), viewModel: BookListViewModel())

            viewController = bookListVC

        case .wishList:
            let wishListVC = WishListViewController.instantiateInitialViewController()
            wishListVC.inject(routing: WishListRouting(), viewModel: WishListViewModel())

            viewController = wishListVC

        case .chatList:
            let chatListVC = ChatUserListViewController.instantiateInitialViewController()

            viewController = chatListVC
        }

        let nc = MainNavigationController(rootViewController: viewController)
        nc.setupNavigationBar(
            forVC: viewController,
            config: viewController as? NavigationBarConfiguration
        )

        return nc
    }

    var viewControllers: UIViewController {
        let viewController = baseViewController
        viewController.tabBarItem = tabBarItem
        return viewController
    }
}
