import UIKit

final class MainNavigationController: UINavigationController {

    private let logoutItem: UIBarButtonItem = UIBarButtonItem(
        image: Resources.Images.Navigation.logout.withRenderingMode(.alwaysOriginal),
        style: .plain,
        target: nil,
        action: nil
    )

    private let doneItem: UIBarButtonItem = UIBarButtonItem(
        title: Resources.Strings.Navigation.done,
        style: .done,
        target: nil,
        action: nil
    )

    private let addBookItem: UIBarButtonItem = UIBarButtonItem(
        title: Resources.Strings.Navigation.add,
        style: .done,
        target: nil,
        action: nil
    )

    private let addUserItem: UIBarButtonItem = UIBarButtonItem(
        image: Resources.Images.Navigation.addUser.withRenderingMode(.alwaysOriginal),
        style: .plain,
        target: nil,
        action: nil
    )

    private let startTalkItem: UIBarButtonItem = UIBarButtonItem(
        title: Resources.Strings.Navigation.startTalk,
        style: .done,
        target: nil,
        action: nil
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

            case .addBook:
                return addBookItem

            case .addUser:
                return addUserItem

            case .startTalk:
                return startTalkItem
            }
        }
    }
}
