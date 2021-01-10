import UIKit

protocol RouterProtocol: class {

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
        _ route:               Route,
        from:                  UIViewController,
        presentationStyle:     UIModalPresentationStyle,
        animated:              Bool,
        isModalInPresentation: Bool,
        completion:            VoidBlock?
    )

    func present(
        _ viewController:      UIViewController,
        from:                  UIViewController,
        presentationStyle:     UIModalPresentationStyle,
        animated:              Bool,
        isModalInPresentation: Bool,
        completion:            VoidBlock?
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
        _ route:               Route,
        from:                  UIViewController,
        presentationStyle:     UIModalPresentationStyle = .pageSheet,
        animated:              Bool = true,
        isModalInPresentation: Bool = true,
        completion:            VoidBlock? = nil
    ) {
        return present(
            route,
            from:                  from,
            presentationStyle:     presentationStyle,
            animated:              animated,
            isModalInPresentation: isModalInPresentation,
            completion:            completion
        )
    }

    func present(
        _ viewController:      UIViewController,
        from:                  UIViewController,
        presentationStyle:     UIModalPresentationStyle = .pageSheet,
        animated:              Bool = true,
        isModalInPresentation: Bool = true,
        completion:            VoidBlock? = nil
    ) {
        return present(
            viewController,
            from:                  from,
            presentationStyle:     presentationStyle,
            animated:              animated,
            isModalInPresentation: isModalInPresentation,
            completion:            completion
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

    case signup
    case login
    case home

    fileprivate func viewController() -> UIViewController {

        let viewController: UIViewController

        switch self {

        case .signup:
            viewController = Resources.ViewControllers.App.signup()

        case .login:
            viewController = Resources.ViewControllers.App.login()

        case .home:
            viewController = Resources.ViewControllers.App.home()
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
        let navVC = from.navigationController

        navVC?.pushViewController(
            vc,
            animated: animated
        )
    }

    func present(
        _ route:               Route,
        from:                  UIViewController,
        presentationStyle:     UIModalPresentationStyle,
        animated:              Bool,
        isModalInPresentation: Bool,
        completion:            VoidBlock?
    ) {
        let vc = route.viewController()

        internalPresent(
            vc,
            from:                  from,
            presentationStyle:     presentationStyle,
            animated:              animated,
            isModalInPresentation: isModalInPresentation,
            completion:            completion
        )
    }

    func present(
        _ viewController:      UIViewController,
        from:                  UIViewController,
        presentationStyle:     UIModalPresentationStyle,
        animated:              Bool,
        isModalInPresentation: Bool,
        completion:            VoidBlock?
    ) {
        internalPresent(
            viewController,
            from:                  from,
            presentationStyle:     presentationStyle,
            animated:              animated,
            isModalInPresentation: isModalInPresentation,
            completion:            completion
        )
    }

    private func internalPresent(
        _ resolvedViewController: UIViewController,
        from:                     UIViewController,
        presentationStyle:        UIModalPresentationStyle,
        animated:                 Bool,
        isModalInPresentation:    Bool,
        completion:               VoidBlock?
    ) {
        let vc = resolvedViewController

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

    func dismiss(
        _ vc:       UIViewController,
        animated:   Bool,
        completion: VoidBlock?
    ) {
        if let nc = vc.navigationController, nc.viewControllers.count > 1 {
            nc.popViewController(animated: animated)
        } else {
            vc.dismiss(
                animated:   animated,
                completion: completion
            )
        }
    }

    func initialWindow(_ route: Route, type: ControllerType) -> UIViewController {
        var viewController: UIViewController

        switch type {

        case .normal:
            viewController = route.viewController()

        case .navigation:
            viewController = UINavigationController(rootViewController: route.viewController())
        }

        return viewController
    }
}
