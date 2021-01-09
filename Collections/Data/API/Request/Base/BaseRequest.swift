import Foundation
import UIKit

protocol BaseRequest {
    associatedtype Request: Encodable
    associatedtype Response: Decodable

    var baseUrl: String { get }

    var path: String { get }

    var url: URL? { get }

    var method: HttpMethod { get }

    var headerFields: [String: String] { get }

    var encoder: JSONEncoder { get }

    var decoder: JSONDecoder { get }

    func request(_ parameter: Request?, completionHandler: ((Result<Response, APIError>) -> Void)?)
}

extension BaseRequest {

    var baseUrl: String {
        AppConfigrator.currentApiUrl.description
    }

    var url: URL? {
        URL(string: baseUrl + path )
    }

    var headerFields: [String: String] {
        [String: String]()
    }

    var defaultHeaderFields: [String: String] {
        ["content-type": "application/json"]
    }

    var encoder: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }

    var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }

    func request(
        _ parameter: Request? = nil,
        completionHandler: ((Result<Response, APIError>) -> Void)? = nil
    ) {
        do {
            let data = parameter == nil ? nil : try encoder.encode(parameter)
            request(data, completionHandler: completionHandler)
        } catch {
            completionHandler?(.failure(.request))
        }
    }

    private func request(
        _ data: Data?,
        completionHandler: ((Result<Response, APIError>) -> Void)? = nil
    ) {
        do {
            guard let url = url,
                  var urlRequest = try method.urlRequest(url: url, data: data)
            else {
                return
            }

            urlRequest.allHTTPHeaderFields = defaultHeaderFields.merging(headerFields) { $1 }
            urlRequest.timeoutInterval = 8

            var dataTask: URLSessionTask!

            dataTask = URLSession.shared.dataTask(with: urlRequest, completionHandler: { data, response, error in
                if let error = error {
                    completionHandler?(.failure(.network(error: error)))
                    return
                }

                guard let data = data,
                      let response = response as? HTTPURLResponse
                else {
                    completionHandler?(.failure(.emptyResponse))
                    return
                }

                guard 200..<300 ~= response.statusCode else {
                    completionHandler?(.failure(.http(status: response.statusCode)))
                    return
                }

                do {
                    let entity = try self.decoder.decode(Response.self, from: data)
                    completionHandler?(.success(entity))
                } catch {
                    completionHandler?(.failure(.decode(error: error)))
                }
            })
            dataTask.resume()
        } catch {
            completionHandler?(.failure(.request))
        }
    }
}
