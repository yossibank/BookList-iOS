import Foundation

public struct AddBookRequest: Request {
    public typealias Response = BookResponse
    public typealias PathComponent = EmptyPathComponent

    public struct Parameters: Codable {
        let name: String
        let image: String?
        let price: Int?
        let purchaseDate: String?
    }

    public var parameters: Parameters
    public var method: HTTPMethod { .post }
    public var path: String { "/books" }
    public var body: Data?
    public var testDataPath: URL? { nil }

    public init(
        parameters: Parameters,
        pathComponent: EmptyPathComponent = .init()
    ) {
        self.parameters = parameters
    }
}
