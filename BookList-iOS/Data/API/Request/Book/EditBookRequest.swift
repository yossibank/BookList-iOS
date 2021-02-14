struct EditBookRequest: BaseRequest {

    typealias Response = EditBookResponse

    struct Request: Encodable {
        var name: String
        var image: String?
        var price: Int?
        var purchaseDate: String?
    }

    var id: Int

    var path: String { "/books/\(id)"}

    var method: HttpMethod { .put }

    var headerFields: [String: String] {
        [Resources.Strings.API.authorization: KeychainManager.shared.getToken() ?? .blank]
    }
}
