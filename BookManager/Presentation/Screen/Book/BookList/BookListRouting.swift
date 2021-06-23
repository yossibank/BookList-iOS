import UIKit

final class BookListRouting: Routing {
    weak var viewController: UIViewController?
}

extension BookListRouting {

    func showAddBookScreen() {
        let addBookVC = Resources.ViewControllers.App.addBook()
        let navVC = viewController?.navigationController as? RootNavigationController
        navVC?.setupNavigationBar(
            forVC: addBookVC,
            config: addBookVC as NavigationBarConfiguration
        )

        navVC?.pushViewController(addBookVC, animated: true)
    }

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
