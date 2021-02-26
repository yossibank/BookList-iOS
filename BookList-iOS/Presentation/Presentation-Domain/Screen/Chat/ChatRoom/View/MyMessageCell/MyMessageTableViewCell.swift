import UIKit

final class MyMessageTableViewCell: UITableViewCell {

    @IBOutlet weak var userMessageTextView: UITextView! {
        didSet {
            userMessageTextView.textContainerInset = .init(top: 8, left: 4, bottom: 4, right: 4)
            userMessageTextView.sizeToFit()
        }
    }

    @IBOutlet weak var sendTimeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        addSubview(
            MyMessageBalloonView(
                frame: CGRect(
                    x: frame.size.width + 30,
                    y: 0,
                    width: 30,
                    height: 30
                )
            )
        )
    }
}
