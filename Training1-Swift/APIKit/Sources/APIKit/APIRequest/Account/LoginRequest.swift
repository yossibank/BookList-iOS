import Foundation

public struct LoginRequest: Request {
    public typealias Response = Repos.Result<UserResponse>
    public typealias PathComponent = EmptyPathComponent

    public struct Parameters: Codable {
        let email: String
        let password: String

        public init(
            email: String,
            password: String
        ) {
            self.email = email
            self.password = password
        }
    }

    public var parameters: Parameters
    public var queryItems: [URLQueryItem]?
    public var method: HTTPMethod { .post }
    public var path: String { "/login" }

    public var successHandler: (Response) -> Void {
        { response in
            SecretDataHolder.accessToken = response.result.token
        }
    }

    public var testDataPath: URL? {
        Bundle.module.url(forResource: "PostLogin", withExtension: "json")
    }

    public init(
        parameters: Parameters,
        pathComponent _: EmptyPathComponent = .init()
    ) {
        self.parameters = parameters
    }
}
