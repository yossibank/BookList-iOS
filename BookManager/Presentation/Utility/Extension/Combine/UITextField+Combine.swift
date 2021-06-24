import Combine
import UIKit

extension UITextField {

    var textDatePickerPublisher: AnyPublisher<String, Never> {
        NotificationCenter
            .default
            .publisher(for: UITextField.textDidEndEditingNotification, object: self)
            .compactMap { $0.object as? UITextField }
            .map { $0.text ?? String.blank }
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
}
