import UIKit

extension Stylable where Self == UILabel {

    init(
        text: String,
        style: ViewStyle<Self>
    ) {
        self.init()
        self.text = text
        self.apply(style)
    }
}

extension ViewStyle where T: UILabel {

    static var fontNormalStyle: ViewStyle<T> {
        ViewStyle<T> {
            $0.font = .systemFont(ofSize: 16)
        }
    }

    static var fontBoldStyle: ViewStyle<T> {
        ViewStyle<T> {
            $0.font = .boldSystemFont(ofSize: 16)
        }
    }
}
