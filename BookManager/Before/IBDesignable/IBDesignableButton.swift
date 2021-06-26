import UIKit

@IBDesignable
extension UIButton {}

class IBDesignableButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    convenience init(type _: UIButton.ButtonType) {
        self.init(frame: .zero)
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
