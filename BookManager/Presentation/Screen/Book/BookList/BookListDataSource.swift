import UIKit

protocol BookListDataSourceDelegate: AnyObject {
    func didSelectFavoriteButton(index: Int)
}

final class BookListDataSource: NSObject {
    var viewModel: BookListViewModel!
    weak var delegate: BookListDataSourceDelegate?

    init(viewModel: BookListViewModel) {
        self.viewModel = viewModel
    }

    func updateCellDataList(book _: BookViewData) {
//        if let index = viewModel.bookList.firstIndex(where: { $0.id == book.id }) {
//
//        }
    }

    func updateFavorite(index _: Int, bookViewData _: BookViewData) {
//        viewModel.bookList[index].isFavorite = !bookViewData.isFavorite
    }
}

extension BookListDataSource: UITableViewDataSource {

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        viewModel.bookList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: BookListTableViewCell.resourceName,
            for: indexPath
        )

        if let bookListCell = cell as? BookListTableViewCell {
            bookListCell.accessoryType = .disclosureIndicator
            bookListCell.delegate = self
            bookListCell.favoriteButton.tag = indexPath.row
            bookListCell.bookImageView.image = nil
            if let book = viewModel.bookList.any(at: indexPath.row) {
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
