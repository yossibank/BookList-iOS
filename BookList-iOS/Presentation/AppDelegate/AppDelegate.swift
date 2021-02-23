import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    private let router: RouterProtocol = Router()

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        FirebaseApp.configure()

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = router.initialWindow(.login, type: .normal)
        window?.makeKeyAndVisible()

        return true
    }
}

