import UIKit

final class OtherMessageTableViewCell: UITableViewCell {

    @IBOutlet weak var userIconImageView: UIImageView!
    @IBOutlet weak var userMessageTextView: UITextView!
    @IBOutlet weak var sendTimeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        userIconImageView.backgroundColor = .white

        addSubview(
            MyMessageBalloonView(
                frame: CGRect(
                    x: userMessageTextView.frame.minX - 10,
                    y: userMessageTextView.frame.minY - 5,
                    width: 30,
                    height: 30
                )
            )
        )
    }
}
