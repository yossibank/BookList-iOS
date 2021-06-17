import APIKit
import Foundation

public struct DomainConfig {
    public static func setup(baseURL: String) {
        DataConfig.setup(baseURL: baseURL)
    }
}
