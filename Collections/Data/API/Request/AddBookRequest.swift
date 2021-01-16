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

    var headerFields: [String : String] { ["Authorization": "GHZ7EV7xGmc8X1NPxw2FqL51X99V_mHYuj_GfaJoYgc"] }
}
