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

        self.present(alert, animated: true)
    }
}
