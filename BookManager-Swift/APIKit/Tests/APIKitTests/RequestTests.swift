import XCTest
@testable import APIKit

final class RequestTests: XCTestCase {
    override func setUpWithError() throws {
        PersistedDataHolder.onboardingFinished = nil
    }

    func testPostSignup() {
        let expectation = XCTestExpectation(description: "post signup")

        Repos.Account.Signup().request(
            useTestData: true,
            parameters: .init(email: "test@test.com", password: "testtest"),
            pathComponent: .init()
        ) { result in
            switch result {
                case let .success(response):
                    XCTAssertNotNil(response)
                    XCTAssertEqual(response.result.email, "test@test.com")
                    expectation.fulfill()

                case let .failure(error):
                    XCTFail(error.localizedDescription)
            }
        }

        wait(for: [expectation], timeout: 3.0)
    }

    func testPostLogin() {
        let expectation = XCTestExpectation(description: "post login")

        Repos.Account.Login().request(
            useTestData: true,
            parameters: .init(email: "test@test.com", password: "testtest"),
            pathComponent: .init()
        ) { result in
            switch result {
                case let .success(response):
                    XCTAssertNotNil(response)
                    XCTAssertEqual(response.result.email, "test@test.com")
                    expectation.fulfill()

                case let .failure(error):
                    XCTFail(error.localizedDescription)
            }
        }

        wait(for: [expectation], timeout: 3.0)
    }

    func testDeleteLogout() {
        let expectation = XCTestExpectation(description: "delete logout")

        Repos.Account.Logout().request(
            useTestData: true,
            parameters: .init(),
            pathComponent: .init()
        ) { result in
            switch result {
                case let .success(response):
                    XCTAssertNotNil(response)
                    expectation.fulfill()

                case let .failure(error):
                    XCTFail(error.localizedDescription)
            }
        }

        wait(for: [expectation], timeout: 3.0)
    }

    func testGetBookList() {
        let expectation = XCTestExpectation(description: "get bookList")

        Repos.Book.Get().request(
            useTestData: true,
            parameters: .init(limit: 20, page: 1),
            pathComponent: .init()
        ) { result in
            switch result {
                case let .success(response):
                    XCTAssertNotNil(response)
                    XCTAssertEqual(response.result.count, 2)
                    expectation.fulfill()

                case let .failure(error):
                    XCTFail(error.localizedDescription)
            }
        }

        wait(for: [expectation], timeout: 3.0)
    }

    func testPostBook() {
        let expectation = XCTestExpectation(description: "post book")

        Repos.Book.Post().request(
            useTestData: true,
            parameters: .init(
                name: "テスト本",
                image: "http://example/hoge.png",
                price: 100,
                purchaseDate: "2017-06-06"
            ),
            pathComponent: .init()
        ) { result in
            switch result {
                case let .success(response):
                    XCTAssertNotNil(response)
                    XCTAssertEqual(response.result.name, "テスト本")
                    expectation.fulfill()

                case let .failure(error):
                    XCTFail(error.localizedDescription)
            }
        }

        wait(for: [expectation], timeout: 3.0)
    }

    func testPutBook() {
        let expectation = XCTestExpectation(description: "put book")

        Repos.Book.Put().request(
            useTestData: true,
            parameters: .init(
                name: "sample",
                image: "http://example/hoge.png",
                price: 4345,
                purchaseDate: "2001-01-01"
            ),
            pathComponent: .init()
        ) { result in
            switch result {
                case let .success(response):
                    XCTAssertNotNil(response)
                    XCTAssertEqual(response.result.name, "sample")
                    expectation.fulfill()

                case let .failure(error):
                    XCTFail(error.localizedDescription)
            }
        }

        wait(for: [expectation], timeout: 3.0)
    }

    func testGetIsFinished() {
        XCTAssertNil(Repos.Onboarding.GetIsFinished().request())

        PersistedDataHolder.onboardingFinished = true

        XCTAssertTrue(Repos.Onboarding.GetIsFinished().request()!)

        PersistedDataHolder.onboardingFinished = false

        XCTAssertFalse(Repos.Onboarding.GetIsFinished().request()!)
    }

    func testSetIsFinished() {
        XCTAssertNil(PersistedDataHolder.onboardingFinished)

        Repos.Onboarding.SetIsFinished().request(parameters: true)

        XCTAssertTrue(PersistedDataHolder.onboardingFinished!)

        Repos.Onboarding.SetIsFinished().request(parameters: false)

        XCTAssertFalse(PersistedDataHolder.onboardingFinished!)
    }
}
