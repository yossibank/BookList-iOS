import UIKit

final class ChatUserListTableViewCell: UITableViewCell {

    @IBOutlet var userIconImageView: UIImageView!
    @IBOutlet var userNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setup(user: User) {
        userNameLabel.text = user.name
        userIconImageView.loadImage(with: .string(urlString: user.imageUrl))
    }
}
