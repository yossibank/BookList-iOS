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
        self.className
    }
}

extension Initializable where Self: UIViewController {
    /**
     storyboardからUIViewControllerを初期化して取得する
     - Parameter customStoryboard: the name of a custom storyboard to load instead of one loaded by classname.
     */
    static func instantiateInitialViewController(
        fromStoryboardOrNil customStoryboard: String? = nil
    ) -> Self {

        let finalStoryboardName = customStoryboard ?? self.resourceName

        let storyboard = UIStoryboard(name: finalStoryboardName, bundle: Bundle(for: self))
        let controller = storyboard.instantiateInitialViewController()

        return controller as! Self
    }
}
