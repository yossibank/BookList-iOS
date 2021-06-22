import UIKit

/**
 * 初期化を簡易かつシンプルなものにする
 */
protocol Initializable: AnyObject {
    static var className: String { get }
    static var resourceName: String { get }
}

/**
 * 匿名でクラスを初期化できるようにする
 */
protocol ClassInitializable: Initializable {
    init()
}

extension NSObject: ClassInitializable {

    class var className: String {
        String(describing: self)
    }

    class var resourceName: String {
        className
    }
}

/*
 MARK: - View Controller Initialization
 */
extension Initializable where Self: UIViewController {
    /**
     storyboardからUIViewControllerを初期化して取得する
     - Parameter customStoryboard: the name of a custom storyboard to load instead of one loaded by classname.
     */
    static func instantiateInitialViewController(
        fromStoryboardOrNil customStoryboard: String? = nil
    ) -> Self {

        let finalStoryboardName = customStoryboard ?? resourceName

        let storyboard = UIStoryboard(name: finalStoryboardName, bundle: Bundle(for: self))
        let controller = storyboard.instantiateInitialViewController()

        return controller as! Self
    }
}

/*
 MARK: - View initialization
 */
extension Initializable where Self: UIView {
    /**
     Xibから任意のカスタムビューを初期化する
     - Parameter customXib: the name of a custom xib if classname != xib name.
     - Parameter Owner: the owner that will be hooked up in first responder of the view hierarchy.
     - Parameter Options: passed to the xib in initalization

     - UINib.instantiate(withOwner:options:)
     */
    @discardableResult
    static func initialize(
        fromXibOrNil customXib: String? = nil,
        ownerOrNil owner: Any? = nil,
        optionsOrNil options: [UINib.OptionsKey: Any]? = nil
    ) -> UIView? {

        let firstView = xib(fromXibOrNil: customXib).instantiate(
            withOwner: owner,
            options: options
        ).first

        return firstView as? UIView
    }

    /**
     XibからUIViewを初期化して取得する
     - Parameter customXib: the name of a custom xib if classname != xib name.

     - UINib.instantiate(withOwner:options)
     */
    static func xib(
        fromXibOrNil customXib: String? = nil
    ) -> UINib {

        let finalXibsName = customXib ?? resourceName

        return UINib(nibName: finalXibsName, bundle: Bundle(for: self))
    }
}
