import UIKit

extension UIWindow {
    /// Return the current top-most view controller.
    public var topViewController: UIViewController? {
        guard var topViewController = self.rootViewController else {
            return nil
        }
        
        while let presentedViewController = topViewController.presentedViewController {
            topViewController = presentedViewController
        }
        
        while let childViewController = topViewController.children.first {
            topViewController = childViewController
        }
        
        return topViewController
    }
}
