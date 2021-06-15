import Foundation

public struct GetOnboardingFinishedRequest: LocalRequest {
    public typealias Response = Bool
    public typealias Parameters = EmptyParameters
    public typealias PathComponent = EmptyPathComponent

    public var localDataInterceptor: (Parameters) -> Response? {
        { _ in
            PersistedDataHolder.onboardingFinished
        }
    }

    public init(parameters: EmptyParameters, pathComponent: EmptyPathComponent) {}
}
