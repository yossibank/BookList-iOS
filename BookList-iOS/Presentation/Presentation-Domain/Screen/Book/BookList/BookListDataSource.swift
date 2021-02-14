import UIKit

protocol BookListDataSourceDelegate: AnyObject {
    func didSelectFavoriteButton(index: Int)
}

final class BookListDataSource: NSObject {
    var cellDataList: [BookViewData] = []
    weak var delegate: BookListDataSourceDelegate?

    func resetCellDataList() {
        self.cellDataList = []
    }
}

extension BookListDataSource: UITableViewDataSource {

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        cellDataList.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: BookListTableViewCell.resourceName,
            for: indexPath
        )

        if let bookListCell = cell as? BookListTableViewCell {
            bookListCell.accessoryType = .disclosureIndicator
            bookListCell.delegate = self
            bookListCell.favoriteButton.tag = indexPath.row
            bookListCell.bookImageView.image = nil
            if let book = cellDataList.any(at: indexPath.row) {
                bookListCell.setup(book: book)
            }
        }

        return cell
    }
}

extension BookListDataSource: BookListCellDelegate {

    func didSelectFavoriteButton(at index: Int) {
        delegate?.didSelectFavoriteButton(index: index)
    }
}
