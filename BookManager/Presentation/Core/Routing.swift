import UIKit

protocol Routing {
    var viewController: UIViewController? { get set }
}

final class NoRouting: Routing {
    var viewController: UIViewController?
}

