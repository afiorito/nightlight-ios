import UIKit

/// The delegate object that provides transition animator and controller for the from below transition.
public class FromBelowTransitioningDelegate: NSObject {
    public static var `default` = FromBelowTransitioningDelegate()
}

extension FromBelowTransitioningDelegate: UIViewControllerTransitioningDelegate {
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animationController = DirectionalAnimationController(style: .present, direction: .below)
        animationController.hasHapticFeedback = true
        
        return animationController
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DirectionalAnimationController(style: .dismiss, direction: .below)
    }
    
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return BasicPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
