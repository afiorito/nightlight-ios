import UIKit

extension UIViewController {
    /**
     Adds the specified view controller as a child of the current view controller.
     
     - parameter child: The view controller to be added as a child.
     */
    public func add(child: UIViewController) {
        addChild(child)
        view.addSubviews(child.view)
        child.didMove(toParent: self)
    }
}
