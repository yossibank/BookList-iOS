import Foundation

public struct LoginRequest: Request {
    public typealias Response = UserResponse
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
    public var method: HTTPMethod { .post }
    public var path: String { "/login" }
    public var body: Data?

    public var testDataPath: URL? {
        Bundle.module.url(forResource: "PostLogin", withExtension: "json")
    }

    public init(
        parameters: Parameters,
        pathComponent: EmptyPathComponent = .init()
    ) {
        self.parameters = parameters
    }
}
