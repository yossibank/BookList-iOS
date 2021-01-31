import Foundation

enum APIError: Error {
    case request
    case network(error: Error)
    case emptyResponse
    case decode(error: Error)
    case http(status: Int)

    enum ErrorCode: Int {
        case badRequest = 400
        case unAuthorized = 401
        case forBidden = 403
        case notFound = 404
        case unknown = 500
    }

    func description() -> String {
        switch self {

        case .request:
            return "リクエストエラー"

        case .network(let error):
            return "ネックワークエラー: \(error.localizedDescription)"

        case .emptyResponse:
            return "空レスポンスエラー"

        case .decode(let error):
            return "デコードエラー: \(error.localizedDescription)"

        case .http(let status):
            return httpErrorDescription(status: status)
        }
    }

    func httpErrorDescription(status: Int) -> String {

        switch ErrorCode(rawValue: status) {

        case .badRequest:
            return "HTTPエラー: \(status) Bad Request."

        case .unAuthorized:
            return "HTTPエラー: \(status) Anauthorized."

        case .forBidden:
            return "HTTPエラー: \(status) Forbidden."

        case .notFound:
            return "HTTPエラー: \(status) Not Found."

        case .unknown:
            return "HTTPエラー: \(status) Unknown Error."

        default:
            return "HTTPエラー: \(status) Unknown Error."
        }
    }
}
