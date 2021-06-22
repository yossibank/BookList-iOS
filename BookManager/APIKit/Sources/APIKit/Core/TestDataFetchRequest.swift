import Foundation

public struct TestDataFetchRequest {
    private var testDataJsonPath: URL?

    public init(testDataJsonPath: URL?) {
        self.testDataJsonPath = testDataJsonPath
    }

    public func fetchLocalTestData<T: Decodable>(responseType _: T.Type) -> Result<T, APIError> {
        do {
            if let result = EmptyResponse() as? T {
                return .success(result)
            }

            guard let url = testDataJsonPath else {
                return .failure(.missingTestJsonDataPath)
            }

            let data = try Data(contentsOf: url)
            let result = try JSONDecoder().decode(T.self, from: data)

            return .success(result)
        } catch {
            return .failure(.decodingError(error.localizedDescription))
        }
    }
}
