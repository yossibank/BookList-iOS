import DomainKit
import Firebase
import Utility

struct PackageConfig {

    static func setup() {
        FirebaseApp.configure()
        DomainConfig.setup(baseURL: API.baseURL)
        UtilityConfig.setup(analytics: FirebaseProvider())
    }
}
