import UIKit

@IBDesignable
extension UITextView {}

class IBDesignableTextView: UITextView {

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
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
        self.setNeedsLayout()
        self.setNeedsDisplay()
        #endif
    }
}
