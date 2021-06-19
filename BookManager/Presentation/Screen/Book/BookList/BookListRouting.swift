import UIKit

final class BookListRouting: Routing {
    weak var viewController: UIViewController?
}

extension BookListRouting {

    func showAddBookScreen() {
        let addBookVC = AddBookViewController.instantiateInitialViewController()
        addBookVC.inject(viewModel: AddBookViewModel())

        let navVC = viewController?.navigationController as? MainNavigationController
        navVC?.setupNavigationBar(
            forVC: addBookVC,
            config: addBookVC as NavigationBarConfiguration
        )

        navVC?.pushViewController(addBookVC, animated: true)
    }
}
