import UIKit

final class ChatUserListTableViewCell: UITableViewCell {

    @IBOutlet var userIconImageView: UIImageView!
    @IBOutlet var userNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setup(user: FirestoreUser) {
        userNameLabel.text = user.name

        ImageLoader.shared
            .loadImage(with: .string(urlString: user.imageUrl)) { [weak self] image, _ in
                guard let self = self else { return }

                self.userIconImageView.image = image
            }
    }
}
