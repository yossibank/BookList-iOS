import FirebaseCore

final class FirebaseManager {

    static let shared = FirebaseManager()

    private init() { }

    func configure() {
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        FirebaseApp.configure()
    }
}
