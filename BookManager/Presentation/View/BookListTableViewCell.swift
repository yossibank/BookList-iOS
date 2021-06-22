import UIKit

protocol BookListCellDelegate: AnyObject {
    func didSelectFavoriteButton(at index: Int)
}

final class BookListTableViewCell: UITableViewCell {

    @IBOutlet var bookImageView: UIImageView!
    @IBOutlet var bookTitleLabel: UILabel!
    @IBOutlet var bookPriceLabel: UILabel!
    @IBOutlet var bookPurchaseLabel: UILabel!
    @IBOutlet var favoriteButton: UIButton! {
        didSet {
            favoriteButton.addTarget(
                self,
                action: #selector(favoriteButtonTapped),
                for: .touchUpInside
            )
        }
    }

    weak var delegate: BookListCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setup(book: BookViewData) {
        bookTitleLabel.text = book.name

        if let purchaseDate = book.purchaseDate {
            if let purchaseDateFormat = Date.toConvertDate(purchaseDate, with: .yearToDayOfWeek) {
                bookPurchaseLabel.text = purchaseDateFormat
                    .toConvertString(with: .yearToDayOfWeekJapanese)
            }
        }

        if let price = book.price {
            bookPriceLabel.text = String.toTaxText(price)
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

    @objc private func favoriteButtonTapped(_ sender: UIButton) {
        delegate?.didSelectFavoriteButton(at: sender.tag)
    }
}
