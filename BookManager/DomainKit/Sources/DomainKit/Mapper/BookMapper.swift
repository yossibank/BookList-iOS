import APIKit
import Foundation

public struct BookMapper {
    func convert(response: BookResponse) -> BookEntity {
        BookEntity(
            id: response.result.id,
            name: response.result.name,
            image: response.result.image,
            price: response.result.price,
            purchaseDate: response.result.purchaseDate
        )
    }
}
