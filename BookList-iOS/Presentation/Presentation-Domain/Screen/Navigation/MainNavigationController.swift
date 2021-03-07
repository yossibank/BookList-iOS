import UIKit

final class MainNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension MainNavigationController {

    func setupNavigationBar(
        forVC vc: UIViewController,
        config: NavigationBarConfiguration?
    ) {
        vc.navigationItem.title = config?.navigationTitle
    }
}
