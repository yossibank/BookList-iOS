import Foundation

public protocol AnalyticsProvider {
    func sendEvent(title: String)
}

public final class Analytics {
    private init() {}

    public static var shared: Analytics = .init()

    var provider: AnalyticsProvider?

    public func sendEvent(title: String = #function) {
        self.provider?.sendEvent(title: title)
    }
}
