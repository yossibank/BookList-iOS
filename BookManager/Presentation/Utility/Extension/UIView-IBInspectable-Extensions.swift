import UIKit

typealias VoidBlock = () -> Void

extension UIView {

    @IBInspectable var layerColor: UIColor? {
        get { return layer.backgroundColor.map { UIColor(cgColor: $0) }}
        set { layer.backgroundColor = newValue?.cgColor }
    }

    @IBInspectable var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }

    @IBInspectable var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }

    @IBInspectable var borderColor: UIColor? {
        get { return layer.borderColor.map { UIColor(cgColor: $0) }}
        set { layer.borderColor = newValue?.cgColor }
    }

    @IBInspectable var shadowRadius: CGFloat {
        get { return layer.shadowRadius }
        set { layer.shadowRadius = newValue }
    }

    @IBInspectable var shadowOpacity: Float {
        get { return layer.shadowOpacity }
        set { layer.shadowOpacity = newValue }
    }

    @IBInspectable var shadowOffset: CGSize {
        get { return layer.shadowOffset }
        set { layer.shadowOffset = newValue }
    }

    @IBInspectable var shadowColor: UIColor? {
        get { return layer.shadowColor.map { UIColor(cgColor: $0 ) }}
        set { layer.shadowColor = newValue?.cgColor }
    }
}
