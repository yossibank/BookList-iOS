//
//  AppDelegate.swift
//  Collections
//
//  Created by KAMIYAMA YOSHIHITO on 2020/12/30.
//

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

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = router.initialWindow(.login, type: .normal)
        window?.makeKeyAndVisible()

        FirebaseApp.configure()

        return true
    }
}

