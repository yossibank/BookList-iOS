import UIKit

final class MyMessageTableViewCell: UITableViewCell {

    @IBOutlet weak var userMessageTextView: UITextView!
    @IBOutlet weak var sendTimeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        addSubview(
            MyMessageBalloonView(
                frame: CGRect(
                    x: userMessageTextView.frame.maxX - 10,
                    y: userMessageTextView.frame.minY - 5,
                    width: 30,
                    height: 30
                )
            )
        )
    }
}
