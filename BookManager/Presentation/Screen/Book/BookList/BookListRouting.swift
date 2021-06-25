import UIKit

final class BookListRouting: Routing {
    weak var viewController: UIViewController?
}

extension BookListRouting {

    func showAddBookScreen(
        successHandler: VoidBlock?
    ) {
        let addBookVC = Resources.ViewControllers.App.addBook(successHandler: successHandler)
        let navVC = RootNavigationController(rootViewController: addBookVC)
        navVC.setupNavigationBar(
            forVC: addBookVC,
            config: addBookVC as NavigationBarConfiguration
        )

        viewController?.present(navVC, animated: true)
    }

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
