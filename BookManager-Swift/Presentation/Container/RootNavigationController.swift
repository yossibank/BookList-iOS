import UIKit

final class RootNavigationController: UINavigationController {

    private let logoutItem = UIBarButtonItem(
        image: Resources.Images.Navigation.logout.withRenderingMode(.alwaysOriginal),
        style: .plain,
        target: nil,
        action: nil
    )

    private let doneItem = UIBarButtonItem(
        title: Resources.Strings.Navigation.done,
        style: .done,
        target: nil,
        action: nil
    )

    private let addBookItem = UIBarButtonItem(
        title: Resources.Strings.Navigation.add,
        style: .done,
        target: nil,
        action: nil
    )

    private let addUserItem = UIBarButtonItem(
        image: Resources.Images.Navigation.addUser.withRenderingMode(.alwaysOriginal),
        style: .plain,
        target: nil,
        action: nil
    )

    private let startTalkItem = UIBarButtonItem(
        title: Resources.Strings.Navigation.startTalk,
        style: .done,
        target: nil,
        action: nil
    )

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension RootNavigationController {

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
