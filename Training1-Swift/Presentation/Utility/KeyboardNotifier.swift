import Combine
import UIKit

final class KeyboardNotifier {
    var keyboardPresent: ((_ keyboardFrame: CGRect) -> Void)?
    var keyboardDismiss: (() -> Void)?

    private var cancellables: Set<AnyCancellable> = []

    func listenKeyboard() {
        NotificationCenter.default
            .publisher(for: UIResponder.keyboardWillChangeFrameNotification)
            .compactMap { ($0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] keyboardFrame in
                self?.keyboardPresent?(keyboardFrame)
            }
            .store(in: &cancellables)

        NotificationCenter.default
            .publisher(for: UIResponder.keyboardWillHideNotification)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.keyboardDismiss?()
            }
            .store(in: &cancellables)
    }
}

protocol KeyboardDelegate: AnyObject {
    var keyboardNotifier: KeyboardNotifier { get set }
    func keyboardPresent(_ keyboardFrame: CGRect)
    func keyboardDismiss()
}

extension KeyboardDelegate {

    func listenerKeyboard(keyboardNotifier: KeyboardNotifier) {
        keyboardNotifier.listenKeyboard()

        keyboardNotifier.keyboardPresent = { keyboardFrame in
            self.keyboardPresent(keyboardFrame)
        }

        keyboardNotifier.keyboardDismiss = {
            self.keyboardDismiss()
        }
    }
}
