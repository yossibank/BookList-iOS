import UIKit

final class BookListDataSource: NSObject {
    private weak var viewModel: BookListViewModel?

    init(viewModel: BookListViewModel) {
        super.init()
        self.viewModel = viewModel
    }
}

extension BookListDataSource: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let cellData = viewModel?.books else { return 0 }
        return cellData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellData = viewModel?.books else {
            return UITableViewCell(style: .default, reuseIdentifier: nil)
        }

        let cell = tableView.dequeueReusableCell(
            withIdentifier: BookListTableViewCell.resourceName,
            for: indexPath
        )

        if let bookListCell = cell as? BookListTableViewCell {
            bookListCell.accessoryType = .disclosureIndicator
            bookListCell.bookImageView.image = nil
            bookListCell.delegate = self
            bookListCell.tableView = tableView
            bookListCell.favoriteButton.tag = indexPath.row
            bookListCell.setup(book: cellData[indexPath.row])
        }

        return cell
    }
}

extension BookListDataSource: BookListCellDelegate {

    func didSelectFavoriteButton(
        at index: Int,
        of cell: BookListTableViewCell,
        tableView: UITableView
    ) {
        guard let cellData = viewModel?.books,
              let bookData = cellData.any(at: index)
        else {
            return
        }

        if bookData.isFavorite {
            viewModel?.removeFavoriteBookData(bookData: bookData)
        } else {
            viewModel?.saveFavoriteBookData(bookData: bookData)
        }

        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .fade)
    }
}
