import APIKit
import Combine
import Foundation
import Utility

protocol Usecase {
    associatedtype Repository
    associatedtype Mapper

    var repository: Repository { get }
    var mapper: Mapper { get }
    var analytics: Analytics { get }
}

public struct NoEntity: Equatable {}

public struct NoMapper {}

public struct UsecaseImpl<R, M>: Usecase {
    var repository: R
    var mapper: M
    var analytics: Analytics = .shared
    var useTestData: Bool

    func toPublisher<T: Equatable, E: Error>(
        closure: @escaping (@escaping Future<T, E>.Promise) -> Void
    ) -> AnyPublisher<T, E> {
        Deferred {
            Future { promise in
                closure(promise)
            }
        }.eraseToAnyPublisher()
    }
}
