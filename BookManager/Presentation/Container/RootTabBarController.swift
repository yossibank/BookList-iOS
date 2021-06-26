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

// MARK: - internal methods

extension RootTabBarController {

    func getViewController(tag: Tabs) -> UIViewController? {
        viewControllers?.any(at: tag.rawValue)?.children.any(at: 0)
    }
}

enum Tabs: Int, CaseIterable {
    case bookList
    case wishList
    case account

    private var title: String {
        switch self {
            case .bookList:
                return Resources.Strings.TabBar.bookList

            case .wishList:
                return Resources.Strings.TabBar.wishList

            case .account:
                return Resources.Strings.TabBar.account
        }
    }

    private var image: UIImage? {
        switch self {
            case .bookList:
                return Resources.Images.TabBar.bookList

            case .wishList:
                return Resources.Images.TabBar.wishList

            case .account:
                return Resources.Images.TabBar.account
        }
    }

    private var tabBarItem: UITabBarItem {
        .init(title: title, image: image, tag: rawValue)
    }

    private var baseViewController: UIViewController {
        let viewController: UIViewController

        switch self {
            case .bookList:
                viewController = Resources.ViewControllers.App.bookList()

            case .wishList:
                viewController = Resources.ViewControllers.App.wishList()

            case .account:
                viewController = Resources.ViewControllers.App.account()
        }

        let nc = RootNavigationController(rootViewController: viewController)
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
