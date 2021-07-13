import UIKit

extension UIImage {

    func convertBase64String() -> String {
        guard case let imageData as NSData = pngData() else {
            return String.blank
        }

        let data = imageData.base64EncodedString(options: .lineLength64Characters)
        return data
    }
}
