import Foundation

public struct LogoutRequest: Request {
    public typealias Parameters = EmptyParameters
    public typealias Response = LogoutResponse
    public typealias PathComponent = EmptyPathComponent

    public var parameters: Parameters
    public var queryItems: [URLQueryItem]?
    public var method: HTTPMethod { .delete }
    public var path: String { "/logout" }
    public var body: Data?
    public var testDataPath: URL? { nil }

    public init(
        parameters: Parameters,
        pathComponent: EmptyPathComponent = .init()
    ) {
        self.parameters = parameters
    }
}
