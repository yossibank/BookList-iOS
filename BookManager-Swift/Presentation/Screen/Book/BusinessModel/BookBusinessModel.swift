import Foundation

struct BookBusinessModel: Codable {
    var id: Int
    var name: String
    var image: String?
    var price: Int?
    var purchaseDate: String?
    var isFavorite: Bool
}

extension BookBusinessModel {

    var json: Data? {
        try? JSONEncoder().encode(self)
    }

    init?(json: Data) {
        if let newValue = try? JSONDecoder().decode(BookBusinessModel.self, from: json) {
            self = newValue
        } else {
            return nil
        }
    }
}
