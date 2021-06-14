import Foundation

public struct SetOnboardingFinishedRequest: LocalRequest {
    public typealias Response = Bool
    public typealias Parameters = EmptyParameters
    public typealias PathComponent = EmptyPathComponent

    public var localDataInterceptor: (EmptyParameters) -> Response? {
        { finished in
            PersistedDataHolder.onboardingFinished = finished
            return EmptyResponse()
        }
    }

    public init(parameters: EmptyParameters, pathComponent: EmptyPathComponent) {}
}
