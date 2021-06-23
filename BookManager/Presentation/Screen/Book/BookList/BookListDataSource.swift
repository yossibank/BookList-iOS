import UIKit

protocol BookListDataSourceDelegate: AnyObject {
    func tappedFavoriteButton()
}

final class BookListDataSource: NSObject {
    weak var delegate: BookListDataSourceDelegate?
    private weak var viewModel: BookListViewModel!

    init(viewModel: BookListViewModel) {
        self.viewModel = viewModel
    }
}

// MARK: - Delegate

extension BookListDataSource: UITableViewDataSource {

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        viewModel.bookList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: BookListTableViewCell.resourceName,
            for: indexPath
        )

        if
            let bookListCell = cell as? BookListTableViewCell,
            let book = viewModel.bookList.any(at: indexPath.row) {

            bookListCell.setup(book: book)
            bookListCell.favoriteHandler = { [weak self] in
                book.isFavorite
                    ? self?.viewModel.removeFavoriteBook(book: book)
                    : self?.viewModel.saveFavoriteBook(book: book)

                tableView.reloadRows(
                    at: [.init(row: indexPath.row, section: 0)],
                    with: .automatic
                )

                self?.delegate?.tappedFavoriteButton()
            }
        }

        return cell
    }
}
