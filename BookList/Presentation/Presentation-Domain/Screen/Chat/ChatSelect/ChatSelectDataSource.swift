import UIKit

final class ChatSelectDataSource: NSObject {
    var roomList: [Room] = []
}

extension ChatSelectDataSource: UITableViewDataSource {

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        roomList.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: ChatSelectTableViewCell.resourceName,
            for: indexPath
        )

        if let chatSelectCell = cell as? ChatSelectTableViewCell {
            chatSelectCell.userNameLabel.text = "hogehoge"
        }

        return cell
    }
}
