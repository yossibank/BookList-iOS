import Combine
import UIKit

extension UIImageView {

    var base64ImagePublisher: AnyPublisher<String, Never> {
        NotificationCenter
            .default
            .publisher(for: .didSetImageIntoImageView)
            .compactMap { $0.userInfo?["base64Image"] as? String }
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
}
