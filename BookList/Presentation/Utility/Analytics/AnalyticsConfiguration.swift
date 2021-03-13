import Foundation

protocol AnalyticsConfiguration {
    var screenName: AnalyticsScreenName? { get }
    func sendScreenView()
}

extension AnalyticsConfiguration {

    var screenName: AnalyticsScreenName? { nil }

    func sendScreenView() {
        if let screenName = screenName {
            FirebaseAnalyticsManager.shared.sendScreenView(screenName)
        }
    }
}
