import Foundation
import Firebase
import Utility

struct FirebaseProvider: AnalyticsProvider {
    func sendEvent(title: String) {
        // TODO: please fix
        Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
            AnalyticsParameterItemID: "id-\(title)",
            AnalyticsParameterItemName: title,
            AnalyticsParameterContentType: "content",
        ])
    }
}
