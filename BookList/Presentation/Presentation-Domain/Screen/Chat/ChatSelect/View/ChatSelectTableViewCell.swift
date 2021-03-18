import UIKit

final class ChatSelectTableViewCell: UITableViewCell {

    @IBOutlet weak var userIconImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var lastMessageLabel: UILabel!
    @IBOutlet weak var sendTimeLabel: UILabel!

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

        ImageLoader.shared.loadImage(
            with: .string(urlString: user.imageUrl)
        ) { [weak self] image, _ in
            guard let self = self else { return }

            self.userIconImageView.image = image
        }

        userNameLabel.text = user.name
        lastMessageLabel.text = room.lastMessage
        sendTimeLabel.text = lastMessageSendAt
    }
}
