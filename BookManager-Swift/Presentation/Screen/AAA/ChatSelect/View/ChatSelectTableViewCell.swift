import UIKit

final class ChatSelectTableViewCell: UITableViewCell {

    @IBOutlet var userIconImageView: UIImageView!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var lastMessageLabel: UILabel!
    @IBOutlet var sendTimeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
