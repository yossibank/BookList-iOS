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
            bookListCell.setup(book: cellData[indexPath.row])
        }

        return cell
    }
}
