import UIKit

typealias VoidBlock = () -> Void

extension UIView {

    @IBInspectable var layerColor: UIColor? {
        get { layer.backgroundColor.map { UIColor(cgColor: $0) }}
        set { layer.backgroundColor = newValue?.cgColor }
    }

    @IBInspectable var cornerRadius: CGFloat {
        get { layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }

    @IBInspectable var borderWidth: CGFloat {
        get { layer.borderWidth }
        set { layer.borderWidth = newValue }
    }

    @IBInspectable var borderColor: UIColor? {
        get { layer.borderColor.map { UIColor(cgColor: $0) }}
        set { layer.borderColor = newValue?.cgColor }
    }

    @IBInspectable var shadowRadius: CGFloat {
        get { layer.shadowRadius }
        set { layer.shadowRadius = newValue }
    }

    @IBInspectable var shadowOpacity: Float {
        get { layer.shadowOpacity }
        set { layer.shadowOpacity = newValue }
    }

    @IBInspectable var shadowOffset: CGSize {
        get { layer.shadowOffset }
        set { layer.shadowOffset = newValue }
    }

    @IBInspectable var shadowColor: UIColor? {
        get { layer.shadowColor.map { UIColor(cgColor: $0) }}
        set { layer.shadowColor = newValue?.cgColor }
    }
}
