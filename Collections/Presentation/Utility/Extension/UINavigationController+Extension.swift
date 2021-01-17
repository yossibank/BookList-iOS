import UIKit

extension UINavigationController {

    func popViewController(animated: Bool, completion: VoidBlock?) {
        popViewController(animated: animated)

        if animated,
           let coordinator = transitionCoordinator {
            coordinator.animate(alongsideTransition: nil) { _ in
                if let completion = completion {
                    completion()
                }
            }
        } else {
            if let completion = completion {
                completion()
            }
        }
    }
}
