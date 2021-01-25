import Foundation

struct BookViewData: Codable {
    var id: Int
    var name: String
    var image: String?
    var price: Int?
    var purchaseDate: String?
    var isFavorite: Bool

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
}

extension BookViewData {

    var json: Data? {
        try? JSONEncoder().encode(self)
    }

    init?(json: Data) {
        if let newValue = try? JSONDecoder().decode(BookViewData.self, from: json) {
            self = newValue
        } else {
            return nil
        }
    }
}
