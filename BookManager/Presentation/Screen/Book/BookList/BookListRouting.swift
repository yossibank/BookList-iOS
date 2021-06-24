import UIKit

final class BookListRouting: Routing {
    weak var viewController: UIViewController?
}

extension BookListRouting {

    func showAddBookScreen(successHandler: VoidBlock?) {
        let addBookVC = Resources.ViewControllers.App.addBook(successHandler: successHandler)
        let navVC = viewController?.navigationController as? RootNavigationController
        navVC?.setupNavigationBar(
            forVC: addBookVC,
            config: addBookVC as NavigationBarConfiguration
        )

        navVC?.pushViewController(addBookVC, animated: true)
    }

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
