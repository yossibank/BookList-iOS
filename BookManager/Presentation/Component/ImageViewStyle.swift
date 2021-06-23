import UIKit

extension Stylable where Self == UIImageView {

    init(style: ViewStyle<Self>) {
        self.init()
        self.apply(style)
    }
}

extension ViewStyle where T == UIImageView {

    static var iconStyle: ViewStyle<T> {
        ViewStyle<T> {
            $0.image = Resources.Images.App.noImage
            $0.layer.cornerRadius = 30
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.lightGray.cgColor
            $0.clipsToBounds = true
        }
    }

    static var bookListImageStyle: ViewStyle<T> {
        ViewStyle<T> {
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.lightGray.cgColor
            $0.layer.cornerRadius = 20
            $0.clipsToBounds = true
        }
    }

    static var bookImageStyle: ViewStyle<T> {
        ViewStyle<T> {
            $0.image = Resources.Images.App.noImage
            $0.layer.cornerRadius = 20
            $0.clipsToBounds = true
        }
    }
}
