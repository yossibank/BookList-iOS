import UIKit

extension Stylable where Self == UIActivityIndicatorView {

    init(style: ViewStyle<Self>) {
        self.init()
        self.apply(style)
    }
}

extension ViewStyle where T == UIActivityIndicatorView {

    static var largeStyle: ViewStyle<T> {
        ViewStyle<T> {
            $0.style = .large
            $0.hidesWhenStopped = true
        }
    }
}
