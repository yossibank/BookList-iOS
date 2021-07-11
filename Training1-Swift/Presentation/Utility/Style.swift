import Foundation
import UIKit

struct ViewStyle<T> {
    let style: (T) -> Void
}

extension ViewStyle {

    func compose(with style: ViewStyle<T>) -> ViewStyle<T> {
        ViewStyle<T> {
            self.style($0)
            style.style($0)
        }
    }
}

protocol Stylable {
    init()
}

extension UIView: Stylable {}

extension Stylable {

    init(style: ViewStyle<Self>) {
        self.init()
        self.apply(style)
    }

    func apply(_ style: ViewStyle<Self>) {
        style.style(self)
    }
}
