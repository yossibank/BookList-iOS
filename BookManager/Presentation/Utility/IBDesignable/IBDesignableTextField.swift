import UIKit

@IBDesignable
extension UITextField {}

class IBDesignableTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    func commonInit() {
        #if TARGET_INTERFACE_BUIDLER
        setNeedsLayout()
        setNeedsDisplay()
        #endif
    }
}

class BorderBottomTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        commonInit()
        setNeedsDisplay()
    }

    func commonInit() {
        layer.backgroundColor = UIColor.white.cgColor
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOpacity = 1.0
        layer.shadowRadius = 0.0
        layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
    }
}
