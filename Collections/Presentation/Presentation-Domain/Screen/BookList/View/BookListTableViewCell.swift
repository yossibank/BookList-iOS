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

    func setup(image: UIImage, title: String, purchaseDate: String, price: String) {
        bookImageView.image = image
        bookTitleLabel.text = title
        bookPurchaseLabel.text = purchaseDate
        bookPriceLabel.text = price
    }
}
