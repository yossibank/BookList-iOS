struct LoginRequest: BaseRequest {

    typealias Response = SignupResponse

    struct Request: Encodable {
        var email: String
        var password: String
    }

    var path: String { "/login" }

    var method: HttpMethod { .post }
}
