import Foundation

public protocol Repo {
    associatedtype T: Request

    func request(
        useTestData: Bool,
        parameters: T.Parameters,
        pathComponent: T.PathComponent,
        completion: @escaping (Result<T.Response, APIError>) -> Void
    )

    func request(
        parameters: T.Parameters,
        pathComponent: T.PathComponent
    ) -> T.Response?
}

public struct Repository<T: Request>: Repo {
    public init() {}

    public func request(
        useTestData: Bool,
        parameters: T.Parameters,
        pathComponent: T.PathComponent,
        completion: @escaping (Result<T.Response, APIError>) -> Void
    ) {
        let item = T(
            parameters: parameters,
            pathComponent: pathComponent
        )

        APIClinet().request(item: item, useTestData: useTestData) { result in
            switch result {
                case let .success(value):
                    item.successHandler(value)

                case let .failure(error):
                    item.failureHandler(error)
            }

            completion(result)
        }
    }

    @discardableResult
    public func request(
        parameters: T.Parameters,
        pathComponent: T.PathComponent
    ) -> T.Response? {
        let item = T(
            parameters: parameters,
            pathComponent: pathComponent
        )

        return item.localDataInterceptor(parameters)
    }
}

public extension Repository where T.Parameters == EmptyParameters {

    func request(
        useTestData: Bool = false,
        pathComponent: T.PathComponent,
        completion: @escaping (Result<T.Response, APIError>) -> Void
    ) {
        request(
            useTestData: useTestData,
            parameters: .init(),
            pathComponent: pathComponent,
            completion: completion
        )
    }

    @discardableResult
    func request(
        pathComponent: T.PathComponent
    ) -> T.Response? {
        let item = T(
            parameters: .init(),
            pathComponent: pathComponent
        )

        return item.localDataInterceptor(.init())
    }
}

public extension Repository where T.PathComponent == EmptyPathComponent {

    func request(
        useTestData: Bool = false,
        parameters: T.Parameters,
        completion: @escaping (Result<T.Response, APIError>) -> Void
    ) {
        request(
            useTestData: useTestData,
            parameters: parameters,
            pathComponent: .init(),
            completion: completion
        )
    }

    @discardableResult
    func request(
        parameters: T.Parameters
    ) -> T.Response? {
        let item = T(
            parameters: parameters,
            pathComponent: .init()
        )

        return item.localDataInterceptor(parameters)
    }
}

public extension Repository where
    T.PathComponent == EmptyPathComponent,
    T.Parameters == EmptyParameters
{
    func request(
        useTestData: Bool = false,
        completion: @escaping (Result<T.Response, APIError>) -> Void
    ) {
        request(
            useTestData: useTestData,
            parameters: .init(),
            pathComponent: .init(),
            completion: completion
        )
    }

    @discardableResult
    func request() -> T.Response? {
        let item = T(
            parameters: .init(),
            pathComponent: .init()
        )

        return item.localDataInterceptor(.init())
    }
}
