import Foundation

public struct DataConfig {
    static var baseURL: String = ""

    public static func setup(baseURL: String) {
        self.baseURL = baseURL
    }

    public static func hasAccessToken() -> Bool {
        SecretDataHolder.accessToken != nil
    }
}
