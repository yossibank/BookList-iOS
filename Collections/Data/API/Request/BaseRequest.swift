import Foundation
import UIKit
import RxSwift

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

    func request(_ parameter: Request) -> Single<Response>
}

extension BaseRequest {

    var baseUrl: String {
        AppConfigurator.currentApiUrl.description
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

    func request(_ parameter: Request) -> Single<Response> {
        do {
            let data = try encoder.encode(parameter)
            return request(data)
        } catch {
            return Single.error(APIError.request)
        }
    }

    private func request(_ data: Data?) -> Single<Response> {
        return Single.create(subscribe: { observer -> Disposable in
            do {
                guard let url = url,
                      var urlRequest = try method.urlRequest(url: url, data: data)
                else {
                    return Disposables.create()
                }

                /**
                 * キャッシュ処理をすると書籍一覧の追加取得と書籍編集後のデータの更新の際に
                 * データが以前のもとと異なるが(limit:page)はキャッシュされているため挙動がおかしくなる
                 */
//                if let cacheResponse = URLCache.shared.cachedResponse(for: urlRequest) {
//                    do {
//                        let cacheData = try decoder.decode(Response.self, from: cacheResponse.data)
//                        observer(.success(cacheData))
//                        return Disposables.create()
//                    } catch {
//                        observer(.failure(APIError.decode(error: error)))
//                        return Disposables.create()
//                    }
//                }

                urlRequest.allHTTPHeaderFields = defaultHeaderFields.merging(headerFields) { $1 }
                urlRequest.timeoutInterval = 8

                URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                    if let error = error {
                        observer(.failure(APIError.network(error: error)))
                        return
                    }

                    guard let data = data,
                          let response = response as? HTTPURLResponse
                    else {
                        observer(.failure(APIError.emptyResponse))
                        return
                    }

                    guard 200..<300 ~= response.statusCode else {
                        observer(.failure(APIError.http(status: response.statusCode)))
                        return
                    }

                    do {
                        let entity = try self.decoder.decode(Response.self, from: data)
                        observer(.success(entity))
                    } catch {
                        observer(.failure(APIError.decode(error: error)))
                    }
                }.resume()

                return Disposables.create()
            } catch {
                observer(.failure(APIError.request))
                return Disposables.create()
            }
        })
    }
}
