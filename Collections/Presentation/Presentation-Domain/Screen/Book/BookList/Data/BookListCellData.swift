import Foundation

struct BookListCellData: Codable {
    var id: Int
    var name: String
    var image: String?
    var price: Int?
    var purchaseDate: String?
    var isFavorite: Bool

    var json: Data? {
        try? JSONEncoder().encode(self)
    }

    init(
        id: Int,
        name: String,
        image: String?,
        price: Int?,
        purchaseDate: String?,
        isFavorite: Bool
    ) {
        self.id = id
        self.name = name
        self.image = image
        self.price = price
        self.purchaseDate = purchaseDate
        self.isFavorite = isFavorite
    }

    init?(json: Data) {
        if let newValue = try? JSONDecoder().decode(BookListCellData.self, from: json) {
            self = newValue
        } else {
            return nil
        }
    }
}
