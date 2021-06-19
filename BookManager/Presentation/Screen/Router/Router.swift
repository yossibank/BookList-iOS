import UIKit

protocol RouterProtocol: AnyObject {

    func push(
        _ route:  Route,
        from:     UIViewController,
        animated: Bool
    )

    func push(
        _ viewController: UIViewController,
        from:             UIViewController,
        animated:         Bool
    )

    func present(
        _ route:                    Route,
        from:                       UIViewController,
        presentationStyle:          UIModalPresentationStyle,
        wrapInNavigationController: Bool,
        animated:                   Bool,
        isModalInPresentation:      Bool,
        completion:                 VoidBlock?
    )

    func present(
        _ viewController:           UIViewController,
        from:                       UIViewController,
        presentationStyle:          UIModalPresentationStyle,
        wrapInNavigationController: Bool,
        animated:                   Bool,
        isModalInPresentation:      Bool,
        completion:                 VoidBlock?
    )

    func dismiss(
        _ vc:       UIViewController,
        animated:   Bool,
        completion: VoidBlock?
    )

    func initialWindow(
        _ route: Route,
        type:    ControllerType
    ) -> UIViewController
}

extension RouterProtocol {

    func push(
        _ route:  Route,
        from:     UIViewController,
        animated: Bool = true
    ) {
        return push(
            route,
            from:     from,
            animated: animated
        )
    }

    func push(
        _ viewController: UIViewController,
        from:             UIViewController,
        animated:         Bool = true
    ) {
        return push(
            viewController,
            from:     from,
            animated: animated
        )
    }

    func present(
        _ route:                    Route,
        from:                       UIViewController,
        presentationStyle:          UIModalPresentationStyle = .pageSheet,
        wrapInNavigationController: Bool = true,
        animated:                   Bool = true,
        isModalInPresentation:      Bool = true,
        completion:                 VoidBlock? = nil
    ) {
        return present(
            route,
            from: from,
            presentationStyle: presentationStyle,
            wrapInNavigationController: wrapInNavigationController,
            animated: animated,
            isModalInPresentation: isModalInPresentation,
            completion: completion
        )
    }

    func present(
        _ viewController:      UIViewController,
        from:                  UIViewController,
        presentationStyle:     UIModalPresentationStyle = .pageSheet,
        wrapInNavigationController: Bool = true,
        animated:              Bool = true,
        isModalInPresentation: Bool = true,
        completion:            VoidBlock? = nil
    ) {
        return present(
            viewController,
            from:                       from,
            presentationStyle:          presentationStyle,
            wrapInNavigationController: wrapInNavigationController,
            animated:                   animated,
            isModalInPresentation:      isModalInPresentation,
            completion:                 completion
        )
    }

    func dismiss(
        _ vc:       UIViewController,
        animated:   Bool = true,
        completion: VoidBlock? = nil
    ) {
        return dismiss(
            vc,
            animated:   animated,
            completion: completion
        )
    }
}

enum Route {

//    case signup
//    case login
    case home
//    case bookList
    case addBook
    case editBook(
            bookId: Int,
            bookData: BookViewData,
            successHandler: ((BookViewData) -> Void)?
         )
    case wishList
    case chatSelect
    case chatUserList
    case chatRoom(roomId: String, user: FirestoreUser)

    fileprivate func viewController() -> UIViewController {

        let viewController: UIViewController

        switch self {

//        case .signup:
//            viewController = Resources.ViewControllers.App.signup()

//        case .login:
//            viewController = Resources.ViewControllers.App.login()

        case .home:
            viewController = Resources.ViewControllers.App.home()

//        case .bookList:
//            viewController = Resources.ViewControllers.App.bookList()

        case .addBook:
            viewController = Resources.ViewControllers.App.addBook()

        case .editBook(
            let bookId,
            let bookViewData,
            let successHandler
        ):

            viewController = Resources.ViewControllers.App.editBook(
                bookId: bookId,
                bookViewData: bookViewData,
                successHandler: successHandler
            )

        case .wishList:
            viewController = Resources.ViewControllers.App.wishList()

        case .chatSelect:
            viewController = Resources.ViewControllers.App.chatSelect()

        case .chatUserList:
            viewController = Resources.ViewControllers.App.chatUserList()

        case .chatRoom(let roomId, let user):
            viewController = Resources.ViewControllers.App.chatRoom(roomId: roomId, user: user)

        }

        return viewController
    }
}

enum ControllerType {
    case normal
    case navigation
}

final class Router: RouterProtocol {

    func push(
        _ route:  Route,
        from:     UIViewController,
        animated: Bool
    ) {
        let destinationViewController = route.viewController()

        internalPush(
            destinationViewController,
            from:     from,
            animated: animated
        )
    }

    func push(
        _ viewController: UIViewController,
        from:             UIViewController,
        animated:         Bool
    ) {
        internalPush(
            viewController,
            from:     from,
            animated: animated
        )
    }

    private func internalPush(
        _ resolvedViewController: UIViewController,
        from:                     UIViewController,
        animated:                 Bool
    ) {
        let vc = resolvedViewController
        let navVC =
            from as? MainNavigationController ??
            from.navigationController as? MainNavigationController

        navVC?.setupNavigationBar(
            forVC: vc,
            config: vc as? NavigationBarConfiguration
        )

        navVC?.pushViewController(
            vc,
            animated: animated
        )
    }

    func present(
        _ route:                    Route,
        from:                       UIViewController,
        presentationStyle:          UIModalPresentationStyle,
        wrapInNavigationController: Bool,
        animated:                   Bool,
        isModalInPresentation:      Bool,
        completion:                 VoidBlock?
    ) {
        let vc = route.viewController()

        internalPresent(
            vc,
            from:                       from,
            presentationStyle:          presentationStyle,
            wrapInNavigationController: wrapInNavigationController,
            animated:                   animated,
            isModalInPresentation:      isModalInPresentation,
            completion:                 completion
        )
    }

    func present(
        _ viewController:           UIViewController,
        from:                       UIViewController,
        presentationStyle:          UIModalPresentationStyle,
        wrapInNavigationController: Bool,
        animated:                   Bool,
        isModalInPresentation:      Bool,
        completion:                 VoidBlock?
    ) {
        internalPresent(
            viewController,
            from:                       from,
            presentationStyle:          presentationStyle,
            wrapInNavigationController: wrapInNavigationController,
            animated:                   animated,
            isModalInPresentation:      isModalInPresentation,
            completion:                 completion
        )
    }

    private func internalPresent(
        _ resolvedViewController:   UIViewController,
        from:                       UIViewController,
        presentationStyle:          UIModalPresentationStyle,
        wrapInNavigationController: Bool,
        animated:                   Bool,
        isModalInPresentation:      Bool,
        completion:                 VoidBlock?
    ) {
        let vc = resolvedViewController

        if wrapInNavigationController {

            let navVC = MainNavigationController.instantiateInitialViewController()

            navVC.modalPresentationStyle = presentationStyle
            navVC.viewControllers = [vc]
            navVC.setupNavigationBar(
                forVC: vc,
                config: vc as? NavigationBarConfiguration
            )

            if #available(iOS 13, *) {
                navVC.isModalInPresentation = isModalInPresentation
            }

            from.present(
                navVC,
                animated:   animated,
                completion: completion
            )
        } else {

            vc.modalPresentationStyle = presentationStyle

            if #available(iOS 13, *) {
                vc.isModalInPresentation = isModalInPresentation
            }

            from.present(
                vc,
                animated:   animated,
                completion: completion
            )
        }
    }

    func dismiss(
        _ vc:       UIViewController,
        animated:   Bool,
        completion: VoidBlock?
    ) {
        if let nc = vc.navigationController, nc.viewControllers.count > 1 {
            nc.popViewController(
                animated: animated
            )
        } else {
            vc.dismiss(
                animated:   animated,
                completion: completion
            )
        }
    }

    func initialWindow(
        _ route: Route,
        type: ControllerType
    ) -> UIViewController {

        var viewController: UIViewController

        switch type {

        case .normal:
            viewController = route.viewController()

        case .navigation:
            let navVC = MainNavigationController.instantiateInitialViewController()
            let vc = route.viewController()

            navVC.viewControllers.insert(vc, at: 0)
            navVC.setupNavigationBar(
                forVC: vc,
                config: vc as? NavigationBarConfiguration
            )

            viewController = navVC
        }

        return viewController
    }
}
