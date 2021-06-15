import Foundation

public struct EditBookRequest: Request {
    public typealias Response = BookResponse

    public struct Parameters: Codable {
        let name: String
        let image: String?
        let price: Int?
        let purchaseDate: String?
    }

    private let id: Int

    public var parameters: Parameters
    public var method: HTTPMethod { .put }
    public var path: String { "/books\(self.id)" }
    public var testDataPath: URL? { nil }

    public init(
        parameters: Parameters,
        pathComponent id: Int
    ) {
        self.parameters = parameters
        self.id = id
    }
}
