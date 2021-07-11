import APIKit
import Foundation

public struct APPError: Error, Equatable {
    let error: APIError

    public init(error: APIError) {
        self.error = error
    }
}
