import UIKit

final class ChatSelectTableViewCell: UITableViewCell {

    @IBOutlet var userIconImageView: UIImageView!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var lastMessageLabel: UILabel!
    @IBOutlet var sendTimeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        userIconImageView.backgroundColor = .white
    }

    func setup(room: Room) {
        let partnerUser = room.users.filter {
            $0.email != FirebaseAuthManager.shared.currentUser?.email
        }.first

        let lastMessageSendAt = room.lastMessageSendAt?.dateValue().toConvertString(
            with: .hourToMinitue
        )

        guard let user = partnerUser else { return }

        userIconImageView.loadImage(with: .string(urlString: user.imageUrl))
        userNameLabel.text = user.name
        lastMessageLabel.text = room.lastMessage
        sendTimeLabel.text = lastMessageSendAt
    }
}
