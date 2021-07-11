import UIKit

@IBDesignable
class IBDesignableView: UIView {

    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    override open func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        commonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    public init() {
        super.init(frame: CGRect.zero)
        commonInit()
    }

    open func commonInit() {
        #if TARGET_INTERFACE_BUILDER
        setNeedsLayout()
        setNeedsDisplay()
        #endif
    }
}
