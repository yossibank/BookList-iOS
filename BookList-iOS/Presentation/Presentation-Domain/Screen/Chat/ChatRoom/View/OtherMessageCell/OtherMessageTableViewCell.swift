import UIKit

final class OtherMessageTableViewCell: UITableViewCell {

    @IBOutlet weak var userIconImageView: UIImageView!

    @IBOutlet weak var userMessageTextView: UITextView! {
        didSet {
            userMessageTextView.textContainerInset = .init(top: 8, left: 4, bottom: 4, right: 4)
            userMessageTextView.sizeToFit()
        }
    }

    @IBOutlet weak var sendTimeLabel: UILabel!

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
}
