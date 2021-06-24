import Foundation

public struct AddBookRequest: Request {
    public typealias Response = Repos.Result<BookResponse>
    public typealias PathComponent = EmptyPathComponent

    public struct Parameters: Codable {
        let name: String
        let image: String?
        let price: Int?
        let purchaseDate: String?

        public init(
            name: String,
            image: String?,
            price: Int?,
            purchaseDate: String?
        ) {
            self.name = name
            self.image = image
            self.price = price
            self.purchaseDate = purchaseDate
        }
    }

    public var parameters: Parameters
    public var queryItems: [URLQueryItem]?
    public var method: HTTPMethod { .post }
    public var path: String { "/books" }

    public var testDataPath: URL? {
        Bundle.module.url(forResource: "PostBook", withExtension: "json")
    }

    public init(
        parameters: Parameters,
        pathComponent _: EmptyPathComponent = .init()
    ) {
        self.parameters = parameters
    }
}
