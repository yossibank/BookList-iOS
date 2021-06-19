struct LogoutRequest: BaseRequest {

    typealias Response = LogoutResponse

    struct Request: Encodable {}

    var path: String { "/logout" }

    var method: HttpMethod { .delete }

    var headerFields: [String: String] {
        ["Authorization": KeychainManager.shared.getToken() ?? .blank]
    }
}
