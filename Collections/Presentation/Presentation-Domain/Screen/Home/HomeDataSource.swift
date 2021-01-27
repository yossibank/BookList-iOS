import UIKit

final class HomeDataSource: NSObject {
    private let cellData = HomeViewData.HomeItem.allCases.compactMap { $0.rawValue }
}

extension HomeDataSource: UITableViewDataSource {

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        cellData.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: HomeTableViewCell.resourceName,
            for: indexPath
        )

        if let cell = cell as? HomeTableViewCell {
            let item = cellData.any(at: indexPath.row)
            if let item = item {
                cell.setup(item: item)
            }
        }

        return cell
    }
}
