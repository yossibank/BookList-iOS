import UIKit

final class ChatUserListDataSource: NSObject {
    var chatUserList: [FirestoreUser] = []
}

extension ChatUserListDataSource: UITableViewDataSource {

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        chatUserList.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: ChatUserListTableViewCell.resourceName,
            for: indexPath
        )

        if let chatUserListCell = cell as? ChatUserListTableViewCell {
            chatUserListCell.selectionStyle = .none

            if let user = chatUserList.any(at: indexPath.row) {
                chatUserListCell.setup(user: user)
            }
        }

        return cell
    }
    
    
}
