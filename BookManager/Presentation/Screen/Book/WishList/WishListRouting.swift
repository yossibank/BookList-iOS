import UIKit

final class WishListRouting: Routing {
    weak var viewController: UIViewController?
}

extension WishListRouting {

    func showEditBookScreen(id: Int, successHandler: VoidBlock?) {
        let editBookVC = Resources.ViewControllers.App.editBook(
            id: id,
            successHandler: successHandler
        )
        let navVC = viewController?.navigationController as? RootNavigationController
        navVC?.setupNavigationBar(
            forVC: editBookVC,
            config: editBookVC as NavigationBarConfiguration
        )

        navVC?.pushViewController(editBookVC, animated: true)
    }
}
