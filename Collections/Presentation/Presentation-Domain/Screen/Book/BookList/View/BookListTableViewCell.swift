import UIKit

protocol BookListCellDelegate: AnyObject {
    func didSelectFavoriteButton(
        at index: Int,
        of cell: BookListTableViewCell,
        tableView: UITableView
    )
}

final class BookListTableViewCell: UITableViewCell {

    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var bookTitleLabel: UILabel!
    @IBOutlet weak var bookPurchaseLabel: UILabel!
    @IBOutlet weak var bookPriceLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton! {
        didSet {
            favoriteButton.addTarget(
                self,
                action: #selector(tappedFavoriteButton),
                for: .touchUpInside
            )
        }
    }

    weak var delegate: BookListCellDelegate?

    var tableView: UITableView = UITableView()
    var isFavorited: Bool = false

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setup(book: BookViewData) {
        bookTitleLabel.text = book.name

        if let purchaseDate = book.purchaseDate {
            if let dateFormat = Date.toConvertDate(purchaseDate, with: .yearToDayOfWeek) {
                bookPurchaseLabel.text = dateFormat.toString(with: .yearToDayOfWeekJapanese)
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

        isFavorited = BookFileManagement.shared.isFavorited(path: String(book.id))

        let image = isFavorited ? Resources.Images.BookList.favorite : Resources.Images.BookList.nonFavorite
        favoriteButton.setImage(image, for: .normal)
    }

    @objc private func tappedFavoriteButton(_ sender: UIButton) {
        delegate?.didSelectFavoriteButton(at: sender.tag, of: self, tableView: tableView)
    }
}
