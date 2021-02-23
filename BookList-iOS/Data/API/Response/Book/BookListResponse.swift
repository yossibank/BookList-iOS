struct BookListResponse: Decodable {
    var status: Int
    var result: [Book]

    struct Book: Decodable {
        var id: Int
        var name: String
        var image: String?
        var price: Int?
        var purchaseDate: String?
    }

    var totalCount: Int?
    var totalPages: Int?
    var currentPage: Int?
    var limit: Int?
}