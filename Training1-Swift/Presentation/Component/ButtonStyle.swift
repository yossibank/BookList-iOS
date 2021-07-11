import UIKit

extension Stylable where Self == UIButton {

    init(
        title: String,
        backgroundColor: UIColor,
        style: ViewStyle<Self>
    ) {
        self.init()
        self.setTitle(title, for: .normal)
        self.backgroundColor = backgroundColor
        self.apply(style)
    }

    init(image: UIImage) {
        self.init()
        self.setImage(image, for: .normal)
    }
}

extension ViewStyle where T: UIButton {

    static var fontNormalStyle: ViewStyle<T> {
        ViewStyle<T> {
            $0.titleLabel?.font = .systemFont(ofSize: 16)
            $0.layer.cornerRadius = 10
        }
    }

    static var fontBoldStyle: ViewStyle<T> {
        ViewStyle<T> {
            $0.titleLabel?.font = .boldSystemFont(ofSize: 16)
            $0.layer.cornerRadius = 10
        }
    }
}
