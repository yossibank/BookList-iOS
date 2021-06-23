import UIKit

final class WishListDataSource: NSObject {
    private weak var viewModel: WishListViewModel!

    init(viewModel: WishListViewModel) {
        super.init()
        self.viewModel = viewModel
    }
}

extension WishListDataSource: UITableViewDataSource {

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        viewModel.bookList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: WishListTableViewCell.resourceName,
            for: indexPath
        )

        if
            let wishListCell = cell as? WishListTableViewCell,
            let book = viewModel.bookList.any(at: indexPath.row) {
            wishListCell.setup(book: book)
        }

        return cell
    }
}
