import UIKit

final class HomeDataSource: NSObject {
    let cellData = HomeViewData.HomeItem.allCases.compactMap { $0.rawValue }
}

extension HomeDataSource: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: HomeTableViewCell.resourceName,
            for: indexPath
        )

        if let cell = cell as? HomeTableViewCell {
            cell.setup(item: cellData[indexPath.row])
        }

        return cell
    }
}
