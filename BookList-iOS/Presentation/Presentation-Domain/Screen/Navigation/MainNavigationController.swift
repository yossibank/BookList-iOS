import UIKit

final class MainNavigationController: UINavigationController {

    private let logoutItem: UIBarButtonItem = UIBarButtonItem(
        customView: MainNavigationButton(image: Resources.Images.General.logout)
    )

    private let doneItem: UIBarButtonItem = UIBarButtonItem(
        customView: MainNavigationButton(text: Resources.Strings.Navigation.done)
    )

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
        vc.navigationItem.backBarButtonItem = UIBarButtonItem(
            title: config?.backButtonTitle,
            style: .plain,
            target: nil,
            action: nil
        )

        let rightBarButtonItems = configurationToBarItems(
            config: config?.rightBarButton
        )

        vc.navigationItem.rightBarButtonItems = rightBarButtonItems
    }

    private func configurationToBarItems(
        config: [NavigationBarButton]?
    ) -> [UIBarButtonItem] {

        (config ?? []).compactMap { barButtonConfig in

            switch barButtonConfig {

            case .logout:
                return logoutItem

            case .done:
                return doneItem
            }
        }
    }
}
