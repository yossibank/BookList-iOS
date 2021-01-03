import UIKit

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"

    func urlRequest(url: URL, data: Data?) throws -> URLRequest? {
        var request = URLRequest(url: url)

        switch self {

        case .get:
            guard let data = data else {
                request.httpMethod = rawValue
                return request
            }

            guard var components = URLComponents(url: url, resolvingAgainstBaseURL: true),
                  let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                return nil
            }
            
            components.queryItems = dictionary.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
            guard let getUrl = components.url else {
                return nil
            }

            var request = URLRequest(url: getUrl)
            request.httpMethod = rawValue
            return request

        case .post, .put, .delete, .patch:
            var request = URLRequest(url: url)
            request.httpMethod = rawValue
            request.httpBody = data
            return request
        }
    }
}
