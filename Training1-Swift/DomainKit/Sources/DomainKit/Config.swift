import APIKit

public struct DomainConfig {

    public static func setup(baseURL: String) {
        DataConfig.setup(baseURL: baseURL)
    }

    public static func hasAccessToken() -> Bool {
        DataConfig.hasAccessToken()
    }
}
