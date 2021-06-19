import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        PackageConfig.setup()

        let initialVC = LoginViewController.instantiateInitialViewController()
        initialVC.inject(routing: LoginRouting(), viewModel: LoginViewModel())

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = initialVC
        window?.makeKeyAndVisible()

        return true
    }
}
