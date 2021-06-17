@testable import APIKit
@testable import DomainKit
import Combine
import XCTest

final class MapperTests: XCTestCase {
    func testUserMapper() {
        let expect: UserEntity = .init(id: 1, email: "test@test.com", token: "token")
        let result = UserMapper().convert(
            response: .init(status: 200, result: .init(id: 1, email: "test@test.com", token: "token"))
        )

        XCTAssertEqual(expect, result)
    }

    func testBookMapper() {
        let expect: BookEntity = .init(id: 1, name: "test", image: "test.png", price: 100, purchaseDate: "2000-01-01")
        let result = BookMapper().convert(
            response: .init(status: 200, result: .init(id: 1, name: "test", image: "test.png", price: 100, purchaseDate: "2000-01-01"))
        )

        XCTAssertEqual(expect, result)
    }

    func testBookListMapper() {
        let expect: [BookEntity] = [.init(id: 1, name: "test", image: "test.png", price: 100, purchaseDate: "2000-01-01")]
        let result = BookListMapper().convert(
            response: .init(
                status: 200,
                result: [.init(id: 1, name: "test", image: "test.png", price: 100, purchaseDate: "2000-01-01")],
                totalCount: 100,
                totalPages: 20,
                currentPage: 1,
                limit: 20
            )
        )

        XCTAssertEqual(expect, result)
    }
}
