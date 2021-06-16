import Foundation

public struct BookResponse: DataStructure {
    public let status: Int
    public let result: Book
    public let totalCount: Int?
    public let totalPages: Int?
    public let currentPage: Int?
    public let limit: Int?

    public struct Book: DataStructure {
        public let id: Int
        public let name: String
        public let image: String?
        public let price: Int?
        public let purchaseDate: String?
    }
}
