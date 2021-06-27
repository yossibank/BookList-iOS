import UIKit

final class KeyboardNotifier {

    var keyboardPresent: ((_ height: CGFloat) -> Void)?
    var keyboardDismiss: ((_ height: CGFloat) -> Void)?

    func listenKeyboard() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillChangeFrameX),
            name: UIApplication.keyboardWillChangeFrameNotification,
            object: nil
        )
    }

    @objc private func keyboardWillChangeFrameX(_ notification: Notification) {
        if
            let endFrame = (
                notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
            )?.cgRectValue
        {
            let keyboardHeight = UIScreen.main.bounds.height - endFrame.origin.y
            if keyboardHeight > 0 {
                keyboardPresent?(keyboardHeight)
            } else {
                keyboardDismiss?(keyboardHeight)
            }
        }
    }
}

protocol KeyboardDelegate: AnyObject {

    var keyboardNotifier: KeyboardNotifier { get set }

    func keyboardPresent(_ height: CGFloat)
    func keyboardDismiss(_ height: CGFloat)
}

extension KeyboardDelegate {

    func listenerKeyboard(keyboardNotifier: KeyboardNotifier) {
        keyboardNotifier.listenKeyboard()

        keyboardNotifier.keyboardPresent = { height in
            self.keyboardPresent(height)
        }

        keyboardNotifier.keyboardDismiss = { height in
            self.keyboardDismiss(height)
        }
    }
}
