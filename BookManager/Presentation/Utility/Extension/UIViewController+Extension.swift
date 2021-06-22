import UIKit

extension UIViewController {

    func showError(
        title: String,
        message: String,
        completion: VoidBlock? = nil
    ) {
        let alert = UIAlertController.createCloseAlert(
            title: title,
            message: message
        ) {
            if let completion = completion {
                completion()
            }
        }

        present(alert, animated: true)
    }

    func showAlert(
        title: String,
        message: String,
        completion: VoidBlock? = nil
    ) {
        let alert = UIAlertController.createActionAlert(
            title: title,
            message: message
        ) { _ in
            if let completion = completion {
                completion()
            }
        }

        present(alert, animated: true)
    }

    func showActionAlert(
        title: String,
        message: String,
        completion: @escaping VoidBlock
    ) {
        let alert = UIAlertController.createAlert(
            title: title,
            message: message
        ) { _ in
            completion()
        }

        present(alert, animated: true)
    }
}
