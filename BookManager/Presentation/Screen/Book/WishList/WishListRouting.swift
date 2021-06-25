import UIKit

final class WishListRouting: Routing {
    weak var viewController: UIViewController?
}

extension WishListRouting {

    func showEditBookScreen(
        book: BookBusinessModel,
        successHandler: ((BookBusinessModel) -> Void)?
    ) {
        let editBookVC = Resources.ViewControllers.App.editBook(
            book: book,
            successHandler: successHandler
        )
        let navVC = RootNavigationController(rootViewController: editBookVC)
        navVC.setupNavigationBar(
            forVC: editBookVC,
            config: editBookVC as NavigationBarConfiguration
        )

        viewController?.present(navVC, animated: true)
    }
}
