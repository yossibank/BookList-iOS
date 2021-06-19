import UIKit

final class WishListRouting: Routing {
    weak var viewController: UIViewController?
}

extension WishListRouting {

    func showEditBookScreen(id: Int) {
        let editBookVC = EditBookViewController.instantiateInitialViewController()
        editBookVC.inject(viewModel: EditBookViewModel(id: id))

        let navVC = viewController?.navigationController as? MainNavigationController
        navVC?.setupNavigationBar(
            forVC: editBookVC,
            config: editBookVC as NavigationBarConfiguration
        )

        navVC?.pushViewController(editBookVC, animated: true)
    }
}
