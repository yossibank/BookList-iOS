import Foundation

public struct SetOnboardingFinishedRequest: LocalRequest {
    public typealias Response = EmptyResponse
    public typealias Parameters = Bool
    public typealias PathComponent = EmptyPathComponent

    public var localDataInterceptor: (Parameters) -> Response? {
        { finished in
            PersistedDataHolder.onboardingFinished = finished
            return EmptyResponse()
        }
    }

    public init(parameters _: Parameters, pathComponent _: EmptyPathComponent) {}
}
