struct EditBookRequest: BaseRequest {

    typealias Response = EditBookResponse

    struct Request: Encodable {
        var name: String
        var image: String?
        var price: Int?
        var purchaseDate: String?
    }

    var id: Int

    var path: String { "books/\(id)"}

    var method: HttpMethod { .put }

    var headerFields: [String : String] { ["Authorization": "GHZ7EV7xGmc8X1NPxw2FqL51X99V_mHYuj_GfaJoYgc"] }
}
