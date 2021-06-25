import DomainKit
import UIKit

extension UIViewController {

    func showAlert(
        title: String? = nil,
        message: String? = nil,
        actions: [UIAlertAction],
        animated: Bool = true,
        completion: VoidBlock? = nil
    ) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )

        actions.forEach { action in
            alert.addAction(action)
        }

        present(
            alert,
            animated: animated,
            completion: completion
        )
    }

    func showSheet(
        title: String? = nil,
        message: String? = nil,
        actions: [UIAlertAction],
        animated: Bool = true,
        completion: VoidBlock? = nil
    ) {
        let sheet = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .actionSheet
        )

        actions.forEach { action in
            sheet.addAction(action)
        }

        sheet.addAction(
            .init(
                title: "キャンセル",
                style: .cancel
            )
        )

        present(
            sheet,
            animated: animated,
            completion: completion
        )
    }

    func showError(error: APPError) {
        showAlert(
            title: "エラー",
            message: error.localizedDescription,
            actions: [.init(title: "OK", style: .cancel)]
        )
    }
}

extension UIViewController {

    var rootViewController: UIViewController? {
        UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController
    }

    func getRootTabBarController() -> RootTabBarController? {
        self.rootViewController as? RootTabBarController
    }
}
