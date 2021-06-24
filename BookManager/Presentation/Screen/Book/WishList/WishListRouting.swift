import UIKit

final class WishListRouting: Routing {
    weak var viewController: UIViewController?
}

extension WishListRouting {

    func showEditBookScreen(book: BookBusinessModel, successHandler: VoidBlock?) {
        let editBookVC = Resources.ViewControllers.App.editBook(
            book: book,
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
