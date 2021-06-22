import UIKit

final class OtherMessageTableViewCell: UITableViewCell {

    @IBOutlet var userIconImageView: UIImageView!

    @IBOutlet var userMessageTextView: UITextView! {
        didSet {
            userMessageTextView.textContainerInset = .init(
                top: 8,
                left: 4,
                bottom: 4,
                right: 4
            )
            userMessageTextView.sizeToFit()
        }
    }

    @IBOutlet var sendTimeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        userIconImageView.backgroundColor = .white

        addSubview(
            OtherMessageBalloonView(
                frame: CGRect(
                    x: userMessageTextView.frame.minX - 10,
                    y: userMessageTextView.frame.minY - 10,
                    width: 50,
                    height: 50
                )
            )
        )
    }

    func setup(chat: ChatMessage) {
        let sendAt = chat.sendAt.dateValue().toConvertString(
            with: .hourToMinitue
        )

        ImageLoader.shared
            .loadImage(with: .string(urlString: chat.iconUrl)) { [weak self] image, _ in
                guard let self = self else { return }

                self.userIconImageView.image = image
            }

        userMessageTextView.text = chat.message
        sendTimeLabel.text = sendAt
    }
}
