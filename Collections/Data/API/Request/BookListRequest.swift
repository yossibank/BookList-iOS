struct BookListRequest: BaseRequest {

    typealias Response = BookListResponse

    struct Request: Encodable {
        var limit: Int
        var page: Int
    }

    var path: String { "/books" }

    var method: HttpMethod { .get }
}
