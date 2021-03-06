import Foundation

public struct BookListRequest: Request {
    public typealias Response = BookListResponse
    public typealias PathComponent = EmptyPathComponent

    public struct Parameters: Codable {
        let limit: Int
        let page: Int

        public init(
            limit: Int = 20,
            page: Int = 1
        ) {
            self.limit = limit
            self.page = page
        }
    }

    public var parameters: Parameters
    public var method: HTTPMethod { .get }
    public var path: String { "/books" }
    public var body: Data?

    public var testDataPath: URL? {
        Bundle.module.url(forResource: "GetBook", withExtension: "json")
    }

    public init(
        parameters: Parameters,
        pathComponent _: EmptyPathComponent = .init()
    ) {
        self.parameters = parameters
    }
}
