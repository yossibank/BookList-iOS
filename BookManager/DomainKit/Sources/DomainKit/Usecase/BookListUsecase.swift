import APIKit
import Combine
import Foundation

public protocol BookListUsecase {
    func fetchBookList(
        isAdditional: Bool
    ) -> AnyPublisher<[BookEntity], APIError>
}

extension UsecaseImpl: BookListUsecase where R == Repos.Book.Get, M == BookListMapper {
    public func fetchBookList(
        isAdditional: Bool
    ) -> AnyPublisher<[BookEntity], APIError> {
        self.toPublisher { promise in
            analytics.sendEvent()

            var pageRequest: Int = 1

            if isAdditional {
                pageRequest += 1
            } else {
                pageRequest = 1
            }

            repository.request(
                useTestData: useTestData,
                parameters: .init(limit: 20, page: pageRequest),
                pathComponent: .init()
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
