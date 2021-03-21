import UIKit

final class ChatRoomDataSource: NSObject {
    var chatMessages: [ChatMessage] = []
}

extension ChatRoomDataSource: UITableViewDataSource {

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        chatMessages.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: MyMessageTableViewCell.resourceName,
            for: indexPath
        )

        if let myMessageCell = cell as? MyMessageTableViewCell {
            myMessageCell.backgroundColor = .clear

            if let chat = chatMessages.any(at: indexPath.row) {
                myMessageCell.setup(chat: chat)
            }
        }

        return cell
    }
}
