import APIKit
import Foundation

public struct BookListMapper {
    func convert(response: [BookResponse]) -> [BookEntity] {
        response.map { response in
            BookEntity(
                id: response.result.id,
                name: response.result.name,
                image: response.result.image,
                price: response.result.price,
                purchaseDate: response.result.purchaseDate
            )
        }
    }
}
