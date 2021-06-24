import Foundation

public struct EditBookRequest: Request {
    public typealias Response = Repos.Result<BookResponse>

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

    private let id: Int

    public var parameters: Parameters
    public var method: HTTPMethod { .put }
    public var path: String { "/books/\(id)" }

    public var testDataPath: URL? {
        Bundle.module.url(forResource: "PutBook", withExtension: "json")
    }

    public init(
        parameters: Parameters,
        pathComponent id: Int
    ) {
        self.parameters = parameters
        self.id = id
    }
}
