import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        PackageConfig.setup()

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = Resources.ViewControllers.App.login()
        window?.makeKeyAndVisible()

        return true
    }
}
