import UIKit

protocol BookListCellDelegate: AnyObject {
    func didSelectFavoriteButton(
        at index: Int,
        of cell: BookListTableViewCell,
        in tableView: UITableView?
    )
}

final class BookListTableViewCell: UITableViewCell {

    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var bookTitleLabel: UILabel!
    @IBOutlet weak var bookPriceLabel: UILabel!
    @IBOutlet weak var bookPurchaseLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton! {
        didSet {
            favoriteButton.addTarget(
                self,
                action: #selector(favoriteButtonTapped),
                for: .touchUpInside
            )
        }
    }

    weak var delegate: BookListCellDelegate?
    weak var tableView: UITableView?

    private var isFavorite: Bool = false

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
                bookPurchaseLabel.text = purchaseDateFormat.toConvertString(with: .yearToDayOfWeekJapanese)
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

        isFavorite = BookFileManager.shared.isFavorite(path: String(book.id))

        let image = isFavorite ?
            Resources.Images.BookList.favorite :
            Resources.Images.BookList.nonFavorite

        favoriteButton.setImage(image, for: .normal)
    }

    @objc private func favoriteButtonTapped(_ sender: UIButton) {
        delegate?.didSelectFavoriteButton(
            at: sender.tag,
            of: self,
            in: tableView
        )
    }
}
