import UIKit

final class ChatSelectTableViewCell: UITableViewCell {

    private let userIconImageView: UIImageView = .init(
        style: .userIconStyle
    )

    private let userNameLabel: UILabel = .init(
        style: .fontBoldStyle
    )

    private let lastMessageLabel: UILabel = .init(
        style: .fontBoldStyle
    )

    private let sendTimeLabel: UILabel = .init(
        style: .smallFontNormalStyle
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

extension ChatSelectTableViewCell {

    func setup(room: Room) {
        let partnerUser = room.users.filter {
            $0.email != FirebaseAuthManager.shared.currentUser?.email
        }.first

        let lastMessageSendAt = room.lastMessageSendAt?.dateValue().toConvertString(
            with: .hourToMinitue
        )

        guard let user = partnerUser else { return }

        userIconImageView.loadImage(with: .string(urlString: user.imageUrl))
        userNameLabel.text = user.name
        lastMessageLabel.text = room.lastMessage
        sendTimeLabel.text = lastMessageSendAt
    }
}

// MARK: - private methods

extension ChatSelectTableViewCell {

    func setupView() {
        backgroundColor = .white

        let viewList = [
            userIconImageView,
            userNameLabel,
            lastMessageLabel,
            sendTimeLabel
        ]

        viewList.forEach {
            contentView.addSubview($0)
        }
    }

    func setupLayout() {
        userIconImageView.layout {
            $0.centerY == centerYAnchor
            $0.leading == leadingAnchor + 10
            $0.widthConstant == 60
            $0.heightConstant == 60
        }

        userNameLabel.layout {
            $0.top == userIconImageView.topAnchor - 5
            $0.leading == userIconImageView.rightAnchor + 20
            $0.heightConstant == 20
        }

        lastMessageLabel.layout {
            $0.top == userNameLabel.bottomAnchor - 10
            $0.leading == userIconImageView.rightAnchor + 20
            $0.heightConstant == 20
        }

        sendTimeLabel.layout {
            $0.top == topAnchor - 10
            $0.trailing == trailingAnchor - 10
        }
    }
}
