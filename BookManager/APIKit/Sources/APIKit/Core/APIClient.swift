import Foundation
import Utility

struct APIClinet {
    func request<R: Request, T>(
        item: R,
        useTestData: Bool = false,
        completion: @escaping (Result<T, APIError>) -> Void
    ) where R.Response == T {
        #if DEBUG
        if useTestData {
            let testDataFetchRequest = TestDataFetchRequest(testDataJsonPath: item.testDataPath)
            completion(testDataFetchRequest.fetchLocalTestData(responseType: T.self))
            return
        }
        #endif

        guard let urlRequest = createURLRequest(item) else {
            completion(.failure(.invalidRequest))
            return
        }

        if let cache = URLCache.shared.cachedResponse(for: urlRequest), item.wantCache {
            self.decode(data: cache.data, completion: completion)
            return
        }

        let task = URLSession.shared.dataTask(with: urlRequest) { data, _, _ in
            guard let data = data else {
                completion(.failure(.responseError))
                return
            }

            decode(data: data, completion: completion)
        }

        task.resume()
    }

    private func decode<T: Decodable>(
        data: Data,
        completion: @escaping (Result<T, APIError>) -> Void
    ) {
        do {
            let value = try JSONDecoder().decode(T.self, from: data)
            completion(.success(value))
        } catch {
            completion(.failure(.decodingError(error.localizedDescription)))
        }
    }

    private func createURLRequest<R: Request>(_ requestItem: R) -> URLRequest? {
        guard
            let fullPath = URL(string: requestItem.baseURL + requestItem.path)
        else {
            return nil
        }

        var urlComponents = URLComponents()
        urlComponents.scheme = fullPath.scheme
        urlComponents.host = fullPath.host
        urlComponents.path = fullPath.path
        urlComponents.port = fullPath.port
        urlComponents.queryItems = requestItem.queryItems

        guard
            let url = urlComponents.url
        else {
            return nil
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = requestItem.method.rawValue
        urlRequest.httpBody = requestItem.body
        requestItem.headers.forEach {
            urlRequest.addValue($1, forHTTPHeaderField: $0)
        }

        Logger.debug(message: urlRequest.curlString)

        return urlRequest
    }
}
