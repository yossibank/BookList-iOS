import UIKit

final class TapAction {

    typealias TapClosure = VoidBlock

    fileprivate static var key = "ON_TAP_KEY"
    private weak var base: UIControl?

    init(_ base: UIControl) {
        self.base = base
    }

    deinit {
        base?.removeTarget(
            self,
            action: #selector(touchUpInside),
            for: .touchUpInside
        )
    }

    var onTouchUpInside: TapClosure? {
        didSet {
            base?.addTarget(
                self,
                action: #selector(touchUpInside),
                for: .touchUpInside
            )
        }
    }

    @objc private func touchUpInside(sender: AnyObject) {
        onTouchUpInside?()
    }
}

extension UIControl {

    func onTap(_ closure: @escaping VoidBlock) {
        self.removeTarget(nil, action: nil, for: .touchUpInside)

        tapAction.onTouchUpInside = closure
    }

    var onTap: (target: Any?, action: Selector)? {
        get {
            return nil
        }
        set {
            self.removeTarget(nil, action: nil, for: .touchUpInside)

            self.tapAction.onTouchUpInside = nil

            if let value = newValue {
                self.addTarget(
                    value.target,
                    action: value.action,
                    for: .touchUpInside
                )
            }
        }
    }

    private var tapAction: TapAction {
        get {
            if let handler = objc_getAssociatedObject(self, &TapAction.key) as? TapAction {
                return handler
            } else {
                self.tapAction = TapAction(self)
                return self.tapAction
            }
        }
        set {
            objc_setAssociatedObject(
                self,
                &TapAction.key,
                newValue,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }
}
