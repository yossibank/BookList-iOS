import UIKit

// MARK: - properties

final class BookListTableViewCell: UITableViewCell {

    private let mainStackView: UIStackView = .init(
        style: .horizontalStyle,
        spacing: 16
    )

    private let bookImageView: UIImageView = .init(
        style: .bookListImageStyle
    )

    private let bookInfoStackView: UIStackView = .init(
        style: .verticalStyle,
        spacing: 0
    )

    private let bookTitleLabel: UILabel = .init(
        text: String.blank,
        style: .largeFontBoldStyle
    )

    private let bookPriceLabel: UILabel = .init(
        text: String.blank,
        style: .fontBoldStyle
    )

    private let bookPurchaseLabel: UILabel = .init(
        text: String.blank,
        style: .fontBoldStyle
    )

    private let favoriteButton: UIButton = .init(
        image: Resources.Images.App.favorite
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

    override func prepareForReuse() {
        super.prepareForReuse()
        bookImageView.image = nil
    }
}

// MARK: - internal methods

extension BookListTableViewCell {

    func setup(book: BookViewData) {
        bookTitleLabel.text = book.name

        if let price = book.price {
            bookPriceLabel.text = String.toTaxText(price)
        }

        if let purchaseDate = book.purchaseDate {
            if let purchaseDateFormat = Date.toConvertDate(purchaseDate, with: .yearToDayOfWeek) {
                bookPurchaseLabel.text = purchaseDateFormat.toConvertString(
                    with: .yearToDayOfWeekJapanese
                )
            }
        }

        if let imageUrl = book.image {
            ImageLoader.shared.loadImage(
                with: .string(urlString: imageUrl)
            ) { [weak self] image, _ in
                guard let self = self else { return }

                self.bookImageView.image = image
            }
        }

        let image = BookFileManager.isContainPath(path: String(book.id))
            ? Resources.Images.App.favorite
            : Resources.Images.App.nonFavorite

        favoriteButton.setImage(image, for: .normal)
    }
}

// MARK: - private methods

private extension BookListTableViewCell {

    func setupView() {
        backgroundColor = .white

        let bookStackViewList = [
            bookTitleLabel,
            bookPriceLabel,
            bookPurchaseLabel
        ]

        bookStackViewList.forEach {
            bookInfoStackView.addArrangedSubview($0)
        }

        let mainStackViewList = [
            bookImageView,
            bookInfoStackView
        ]

        mainStackViewList.forEach {
            mainStackView.addArrangedSubview($0)
        }

        addSubview(mainStackView)
    }

    func setupLayout() {
        mainStackView.layout {
            $0.centerY == centerYAnchor
            $0.leading.equal(to: leadingAnchor, offsetBy: 16)
            $0.trailing.equal(to: trailingAnchor, offsetBy: -64)
        }

        bookImageView.layout {
            $0.widthConstant == 100
            $0.heightConstant == 100
        }

        bookTitleLabel.layout {
            $0.heightConstant == 40
        }

        [bookPriceLabel, bookPurchaseLabel].forEach {
            $0.layout {
                $0.heightConstant == 30
            }
        }
    }
}
