import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(
        _: UIApplication,
        didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        PackageConfig.setup()

        let rootViewController: UIViewController

        if PackageConfig.hasAccessToken() {
            rootViewController = RootTabBarController()
        } else {
            rootViewController = Resources.ViewControllers.App.login()
        }

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()

        return true
    }
}
