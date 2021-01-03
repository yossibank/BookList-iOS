import Foundation

enum APIError: Error {
    case request
    case network(error: Error? = nil)
    case emptyResponse
    case decode(error: Error)
    case http(status: Int)

    func description() -> String {
        switch self {

        case .request:
            return "リクエストエラー"

        case .network(let error):
            if let error = error {
                return "エラー:\n\(error)"
            }
            return "ネットワークエラー"

        case .emptyResponse:
            return "レスポンスが空です"

        case .decode(let error):
            return "デコードエラー\n\(error)"

        case .http(let status):
            switch status {

            case 400:
                return "HTTPエラー: \(status)\n Bad Request."

            case 401:
                return "HTTPエラー: \(status)\n Anauthorized."

            case 403:
                return "HTTPエラー: \(status)\n Forbidden."

            case 404:
                return "HTTPエラー: \(status)\n Not Found."

            default:
                return "HTTPエラー: \(status)\n Unknown Error."
            }
        }
    }
}
