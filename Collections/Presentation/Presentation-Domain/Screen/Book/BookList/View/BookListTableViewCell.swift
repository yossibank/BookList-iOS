import UIKit

final class BookListTableViewCell: UITableViewCell {

    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var bookTitleLabel: UILabel!
    @IBOutlet weak var bookPurchaseLabel: UILabel!
    @IBOutlet weak var bookPriceLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setup(book: BookListCellData) {
        bookTitleLabel.text = book.name

        if let purchaseDate = book.purchaseDate {
            bookPurchaseLabel.text = purchaseDate
        }

        if let price = book.price {
            bookPriceLabel.text = String(price)
        }

        if let imageUrl = book.image {
            ImageLoader.shared.loadImage(with: .string(urlString: imageUrl)) { [weak self] image, _ in
                guard let self = self else { return }

                self.bookImageView.image = image
            }
        }
    }
}
