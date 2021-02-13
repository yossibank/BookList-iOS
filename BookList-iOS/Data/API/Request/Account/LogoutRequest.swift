struct LogoutRequest: BaseRequest {

    typealias Response = LogoutResponse

    struct Request: Encodable {}

    var path: String { "/logout" }

    var method: HttpMethod { .delete }
    
    var headerFields: [String: String] {
        [Resources.Strings.API.authorization: KeychainManager.shared.getToken() ?? .blank]
    }
}
