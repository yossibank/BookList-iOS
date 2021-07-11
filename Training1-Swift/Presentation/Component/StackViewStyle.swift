import UIKit

extension Stylable where Self == UIStackView {

    init(
        style: ViewStyle<Self>,
        alignment: UIStackView.Alignment = .fill,
        distribution: UIStackView.Distribution = .fill,
        spacing: CGFloat
    ) {
        self.init()
        self.spacing = spacing
        self.alignment = alignment
        self.distribution = distribution
        self.apply(style)
    }
}

extension ViewStyle where T == UIStackView {

    static var horizontalStyle: ViewStyle<T> {
        ViewStyle<T> {
            $0.axis = .horizontal
        }
    }

    static var verticalStyle: ViewStyle<T> {
        ViewStyle<T> {
            $0.axis = .vertical
        }
    }
}
