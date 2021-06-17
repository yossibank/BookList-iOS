import APIKit
import Combine
import Foundation

public protocol EditBookUsecase {
    func updateBook(
        id: Int,
        name: String,
        image: String,
        price: Int,
        purchaseDate: String
    ) -> AnyPublisher<BookEntity, APIError>
}

extension UsecaseImpl where R == Repos.Book.Put, M == BookMapper {
    public func updateBook(
        id: Int,
        name: String,
        image: String,
        price: Int,
        purchaseDate: String
    ) -> AnyPublisher<BookEntity, APIError> {
        self.toPublisher { promise in
            analytics.sendEvent()

            repository.request(
                useTestData: useTestData,
                parameters: .init(name: name, image: image, price: price, purchaseDate: purchaseDate),
                pathComponent: id
            ) { result in
                switch result {
                case let .success(response):
                    let entity = mapper.convert(response: response)
                    promise(.success(entity))

                case let .failure(error):
                    promise(.failure(error))
                }
            }
        }
    }
}
