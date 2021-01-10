import UIKit

extension UIAlertController {

    static func createAlert(
        title: String,
        message: String,
        handler: @escaping (UIAlertAction) -> Void
    ) -> UIAlertController {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )

        alert.addAction(
            title: Resources.Strings.General.yes,
            style: .default,
            handler: handler
        )

        alert.addAction(
            title: Resources.Strings.General.close,
            style: .cancel
        )

        return alert
    }

    static func createCloseAlert(
        title: String,
        message: String,
        completion: VoidBlock? = nil
    ) -> UIAlertController {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )

        alert.addAction(
            title: Resources.Strings.General.close,
            style: .cancel
        ) { _ in
            if let completion = completion {
                completion()
            }
        }

        return alert
    }

    private func addAction(
        title: String?,
        style: UIAlertAction.Style = .default,
        handler: ((UIAlertAction) -> Void)? = nil
    ) {
        let action = UIAlertAction(
            title: title,
            style: style,
            handler: handler
        )
        self.addAction(action)
    }
}
