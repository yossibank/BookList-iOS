import UIKit

final class HomeDataSource: NSObject {
    private let cellData = HomeViewData.HomeItem.allCases.map { $0.rawValue }
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

        if let homeCell = cell as? HomeTableViewCell,
           let item = cellData.any(at: indexPath.row) {
            homeCell.setup(item: item)
        }

        return cell
    }
}
