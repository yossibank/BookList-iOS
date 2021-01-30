import Foundation
import FirebaseAnalytics

final class FirebaseAnalyticsManager {

    static let shared = FirebaseAnalyticsManager()

    private init() { }

    func sendScreenView(_ screenView: AnalyticsScreenName) {
        Analytics.logEvent(screenView.rawValue, parameters: nil)
    }
}
