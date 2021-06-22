import Combine
import XCTest

extension XCTestCase {

    func awaitPublisher<T: Publisher>(
        _ publisher: T,
        timeout: TimeInterval = 10,
        file: StaticString = #file,
        line: UInt = #line
    ) throws -> T.Output {
        var result: Result<T.Output, Error>?
        let expectation = self.expectation(description: "Awaiting publisher")

        let cancellables = publisher.sink(
            receiveCompletion: { completion in
                switch completion {
                    case let .failure(error):
                        result = .failure(error)

                    case .finished:
                        break
                }

                expectation.fulfill()
            },
            receiveValue: { value in
                result = .success(value)
            }
        )

        waitForExpectations(timeout: timeout)
        cancellables.cancel()

        let unwrapResult = try XCTUnwrap(
            result,
            "Await publisher did not produce any output",
            file: file,
            line: line
        )

        return try unwrapResult.get()
    }
}
