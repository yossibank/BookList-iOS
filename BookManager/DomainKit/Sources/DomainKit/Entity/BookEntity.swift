import Foundation

public struct BookEntity: Equatable {
    let id: Int
    let name: String
    let image: String?
    let price: Int?
    let purchaseDate: String?
}
