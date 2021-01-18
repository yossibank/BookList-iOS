struct AddBookRequest: BaseRequest {

    typealias Response = AddBookResponse

    struct Request: Encodable {
        var name: String
        var image: String?
        var price: Int?
        var purchaseDate: String?
    }

    var path: String { "/books" }

    var method: HttpMethod { .post }

    var headerFields: [String : String] { ["Authorization": KeychainManager.shared.getToken() ?? .blank] }
}
