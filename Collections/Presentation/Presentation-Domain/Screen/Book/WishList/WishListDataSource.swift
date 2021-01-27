import UIKit

final class WishListDataSource: NSObject {
    private weak var viewModel: WishListViewModel?
    
    init(viewModel: WishListViewModel) {
        super.init()
        self.viewModel = viewModel
    }
}

extension WishListDataSource: UITableViewDataSource {

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        guard let cellData = viewModel?.books else { return 0 }
        return cellData.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cellData = viewModel?.books else {
            return UITableViewCell(style: .default, reuseIdentifier: nil)
        }

        let cell = tableView.dequeueReusableCell(
            withIdentifier: WishListTableViewCell.resourceName,
            for: indexPath
        )

        if let wishListCell = cell as? WishListTableViewCell {
            wishListCell.accessoryType = .disclosureIndicator
            wishListCell.bookImageView.image = nil
            if let book = cellData.any(at: indexPath.row) {
                wishListCell.setup(book: book)
            }
        }

        return cell
    }
}
