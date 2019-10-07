import UIKit

public class BottomTransition: NSObject {
    let animation: EdgeAnimation = {
        let animation = EdgeAnimation(.bottom)
        animation.hasHapticFeedback = true
        return animation
    }()
}

// MARK: - UIViewControllerTransitioningDelegate

extension BottomTransition: UIViewControllerTransitioningDelegate {
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        animation.operation = .present
        animation.targetViewController = presented

        return animation
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animation.operation = .dismiss
        return animation
    }
    
    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard animation.isInteractive else { return nil }
        
        animation.operation = .dismiss
        return animation
    }
    
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return BasicPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
