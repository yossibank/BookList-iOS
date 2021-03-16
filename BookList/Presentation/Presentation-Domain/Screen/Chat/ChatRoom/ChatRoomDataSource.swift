import UIKit

final class ChatRoomDataSource: NSObject {
    private weak var viewModel: ChatRoomViewModel?

    init(viewModel: ChatRoomViewModel) {
        super.init()
        self.viewModel = viewModel
    }
}

extension ChatRoomDataSource: UITableViewDataSource {

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        guard let cellData = viewModel?.messages else { return 0 }
        return cellData.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cellData = viewModel?.messages else {
            return UITableViewCell(style: .default, reuseIdentifier: nil)
        }

        let cell = tableView.dequeueReusableCell(
            withIdentifier: MyMessageTableViewCell.resourceName,
            for: indexPath
        )

        if let myMessageCell = cell as? MyMessageTableViewCell {
            myMessageCell.backgroundColor = .clear

            if let message = cellData.any(at: indexPath.row) {
                myMessageCell.userMessageTextView.text = message
            }
        }

        return cell
    }
}
