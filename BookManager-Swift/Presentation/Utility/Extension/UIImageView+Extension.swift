import Nuke
import UIKit

extension UIImageView {

    enum ImageType {
        case string(urlString: String?)
        case url(url: URL?)
    }

    func loadImage(with type: ImageType) {

        var imageUrl: URL? {

            if case let .string(imageUrlString) = type {

                if let urlString = imageUrlString {
                    return URL(string: urlString)
                } else {
                    return nil
                }

            } else if case let .url(imageUrl) = type {

                if let string = imageUrl?.absoluteString {

                    guard let urlString = URL(string: string) else {
                        return imageUrl
                    }

                    return urlString
                }
            }

            return nil
        }

        guard let url = imageUrl else {
            self.image = Resources.Images.App.noImage
            return
        }

        Nuke.loadImage(with: url, into: self)
    }
}

