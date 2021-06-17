import APIKit
import Combine
import Foundation

public protocol LoginUsecase {
    func login(
        email: String,
        password: String
    ) -> AnyPublisher<UserEntity, APIError>
}

extension UsecaseImpl where R == Repos.Account.Login, M == UserMapper {
    public func login(
        email: String,
        password: String
    ) -> AnyPublisher<UserEntity, APIError> {
        self.toPublisher { promise in
            analytics.sendEvent()

            repository.request(
                useTestData: useTestData,
                parameters: .init(email: email, password: password),
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
