import UIKit

final class ChatUserListTableViewCell: UITableViewCell {

    private let userIconImageView: UIImageView = .init(
        style: .userIconStyle
    )

    private let userNameLabel: UILabel = .init(
        style: .fontBoldStyle
    )

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupLayout()
    }
}

// MARK: - internal methods

extension ChatUserListTableViewCell {

    func setup(user: User) {
        userNameLabel.text = user.name
        userIconImageView.loadImage(with: .string(urlString: user.imageUrl))
    }
}

// MARK: - private methods

private extension ChatUserListTableViewCell {

    func setupView() {
        backgroundColor = .white
        contentView.addSubview(userIconImageView)
        contentView.addSubview(userNameLabel)
    }

    func setupLayout() {
        userIconImageView.layout {
            $0.centerY == centerYAnchor
            $0.leading == leadingAnchor + 10
            $0.widthConstant == 60
            $0.heightConstant == 60
        }

        userNameLabel.layout {
            $0.centerY == centerYAnchor
            $0.leading == userIconImageView.rightAnchor + 15
        }
    }
}
