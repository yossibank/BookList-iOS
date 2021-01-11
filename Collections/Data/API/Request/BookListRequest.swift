struct BookListRequest: BaseRequest {

    typealias Response = BookListResponse

    struct Request: Encodable {
        var limit: Int
        var page: Int
    }

    var path: String { "/books" }

    var method: HttpMethod { .get }

    var headerFields: [String : String] { ["Authorization": "GHZ7EV7xGmc8X1NPxw2FqL51X99V_mHYuj_GfaJoYgc"] }
}
