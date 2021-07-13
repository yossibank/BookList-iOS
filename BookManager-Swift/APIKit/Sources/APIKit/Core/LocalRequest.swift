import Foundation

protocol LocalRequest: Request {}

extension LocalRequest {
    public var method: HTTPMethod { fatalError() }
    public var parameters: Parameters { fatalError() }
    public var path: String { fatalError() }
    public var testDataPath: URL? { nil }
}
