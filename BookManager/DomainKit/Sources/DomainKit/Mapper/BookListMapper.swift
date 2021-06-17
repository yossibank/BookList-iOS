import APIKit
import Foundation

public struct BookListMapper {
    func convert(response: BookListResponse) -> [BookEntity] {
        response.result.map { response in
            BookEntity(
                id: response.id,
                name: response.name,
                image: response.image,
                price: response.price,
                purchaseDate: response.purchaseDate
            )
        }
    }
}
