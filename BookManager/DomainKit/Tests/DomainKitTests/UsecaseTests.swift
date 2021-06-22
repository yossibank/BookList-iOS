@testable import APIKit
@testable import DomainKit
import Combine
import XCTest

final class UsecaseTests: XCTestCase {

    func testSignupUsecase() throws {
        let expect = try TestDataFetchRequest(
            testDataJsonPath: SignupRequest(
                parameters: .init(email: "test@test.com", password: "test")
            ).testDataPath
        )
        .fetchLocalTestData(responseType: Repos.Result<UserResponse>.self)
        .map(UserMapper().convert)
        .get()

        let result = try awaitPublisher(
            Domain.Usecase.Account
                .Signup(useTestData: true)
                .signup(email: "test@test.com", password: "test")
        )

        XCTAssertEqual(expect, result)
    }

    func testLoginUsecase() throws {
        let expect = try TestDataFetchRequest(
            testDataJsonPath: LoginRequest(
                parameters: .init(email: "test@test.com", password: "test")
            ).testDataPath
        )
        .fetchLocalTestData(responseType: Repos.Result<UserResponse>.self)
        .map(UserMapper().convert)
        .get()

        let result = try awaitPublisher(
            Domain.Usecase.Account
                .Login(useTestData: true)
                .login(email: "test@test.com", password: "test")
        )

        XCTAssertEqual(expect, result)
    }

    func testAddBookUsecase() throws {
        let expect = try TestDataFetchRequest(
            testDataJsonPath: AddBookRequest(
                parameters: .init(
                    name: "test",
                    image: "test.png",
                    price: 100,
                    purchaseDate: "2020-01-01"
                )
            ).testDataPath
        )
        .fetchLocalTestData(responseType: Repos.Result<BookResponse>.self)
        .map(BookMapper().convert)
        .get()

        let result = try awaitPublisher(
            Domain.Usecase.Book
                .AddBook(useTestData: true)
                .addBook(name: "test", image: "test.png", price: 100, purchaseDate: "2020-01-01")
        )

        XCTAssertEqual(expect, result)
    }

    func testEditBookUsecase() throws {
        let expect = try TestDataFetchRequest(
            testDataJsonPath: EditBookRequest(
                parameters: .init(
                    name: "test",
                    image: "test.png",
                    price: 100,
                    purchaseDate: "2020-01-01"
                ),
                pathComponent: 1
            ).testDataPath
        )
        .fetchLocalTestData(responseType: Repos.Result<BookResponse>.self)
        .map(BookMapper().convert)
        .get()

        let result = try awaitPublisher(
            Domain.Usecase.Book
                .EditBook(useTestData: true)
                .updateBook(
                    id: 1,
                    name: "test",
                    image: "test.png",
                    price: 100,
                    purchaseDate: "2020-01-01"
                )
        )

        XCTAssertEqual(expect, result)
    }

    func testBookListUsecase() throws {
        let expect = try TestDataFetchRequest(
            testDataJsonPath: BookListRequest(
                parameters: .init(limit: 20, page: 1)
            ).testDataPath
        )
        .fetchLocalTestData(responseType: BookListResponse.self)
        .map(BookListMapper().convert)
        .get()

        let result = try awaitPublisher(
            Domain.Usecase.Book
                .FetchBookList(useTestData: true)
                .fetchBookList(pageRequest: 1)
        )

        XCTAssertEqual(expect, result)
    }
}
