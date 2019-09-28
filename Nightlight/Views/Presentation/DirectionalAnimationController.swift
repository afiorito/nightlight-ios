import UIKit

/// The object responsible for coordinating a modal view controller transition.
public class DirectionalAnimationController: NSObject {
    /// A constant for representing the transition style.
    public enum TransitionStyle {
        case present
        case dismiss
    }
    
    /// A constant for denoting the direction the presented view animates from.
    public enum PresentationDirection {
        case below
        case above
        case left
        case right
        case center
    }
    
    /// The transition style of the animation.
    private let transitionStyle: TransitionStyle
    
    /// The direction the presented view controller animates from.
    private let presentationDirection: PresentationDirection
    
    /// A generator for announcing that the presented view has appeared.
    private var feedbackGenerator: UISelectionFeedbackGenerator?
    
    /// The initial alpha of the view for the presentation.
    public var initialAlpha: CGFloat = 1.0
    
    /// The duration of the transition animation.
    public var transitionDuration: TimeInterval = 0.5
    
    /// A boolean denoting if the beginning of the animation has haptic feedback.
    public var hasHapticFeedback = false

    /// The spring damping constant for the presentation.
    public var springDamping: CGFloat = 0.8
    
    /// The animation options for the presentation.
    public var animationOptions: UIView.AnimationOptions = [.curveEaseInOut, .allowUserInteraction, .beginFromCurrentState]
    
    required public init(style: TransitionStyle, direction: PresentationDirection) {
        self.transitionStyle = style
        self.presentationDirection = direction
        super.init()
        
        if case .present = transitionStyle {
            feedbackGenerator = UISelectionFeedbackGenerator()
            feedbackGenerator?.prepare()
        }
    }
    
    /**
     Executes the presentation transition.
     
     - parameter transitionContext: the context object containing information to use during the transition.
     */
    private func present(transitionContext: UIViewControllerContextTransitioning) {
        guard
            let toViewController = transitionContext.viewController(forKey: .to),
            let fromViewController = transitionContext.viewController(forKey: .from)
            else { return }
        
        fromViewController.beginAppearanceTransition(false, animated: true)
        toViewController.beginAppearanceTransition(true, animated: true)
        
        let toView: UIView = toViewController.view
        toView.alpha = initialAlpha
       
        let (startFrame, endFrame) = targetFrame(for: toViewController, using: transitionContext)
        toView.frame = startFrame
        
        if hasHapticFeedback {
            feedbackGenerator?.selectionChanged()
        }

        animate({
            toView.frame = endFrame
            toView.alpha = 1.0
        }, completion: { completed in
            fromViewController.endAppearanceTransition()
            toViewController.endAppearanceTransition()
            transitionContext.completeTransition(completed)
        })
    }
    
    /**
     Executes the dismissal transition.
     
     - parameter transitionContext: The context object containing information to use during the transition.
     */
    private func dismiss(transitionContext: UIViewControllerContextTransitioning) {
        guard
            let toViewController = transitionContext.viewController(forKey: .to),
            let fromViewController = transitionContext.viewController(forKey: .from)
            else { return }
        
        fromViewController.beginAppearanceTransition(false, animated: true)
        toViewController.beginAppearanceTransition(true, animated: true)
        
        let fromView: UIView = fromViewController.view
        
        let (startFrame, endFrame) = targetFrame(for: fromViewController, using: transitionContext)
        fromView.frame = endFrame
        
        animate({
            fromView.frame = startFrame
            fromView.alpha = self.initialAlpha
        }, completion: { completed in
            fromViewController.endAppearanceTransition()
            toViewController.endAppearanceTransition()
            transitionContext.completeTransition(completed)
        })
    }
    
    /**
     Performs the animations.
     */
    private func animate(_ animations: @escaping CustomPresentable.AnimationBlockType, completion: CustomPresentable.AnimationCompletionType? = nil) {
        
        UIView.animate(withDuration: transitionDuration, delay: 0, usingSpringWithDamping: springDamping, initialSpringVelocity: 0, options: animationOptions, animations: animations, completion: completion)
    }
    
    /**
     Computes the target start and end frames for the given view controller.
     
     - parameter viewController: The view controller to compute start and end frames for.
     - parameter transitionContext: The context object containing information to use during the transition.
     */
    private func targetFrame(for viewController: UIViewController, using transitionContext: UIViewControllerContextTransitioning) -> (start: CGRect, end: CGRect) {
        let containerView = transitionContext.containerView
        let finalFrame = transitionContext.finalFrame(for: viewController)
        var startFrame = finalFrame
        
        switch presentationDirection {
        case .below: startFrame.origin.y = containerView.frame.height
        case .above: startFrame.origin.y = -containerView.frame.height
        case  .left: startFrame.origin.x = -containerView.frame.width
        case .right: startFrame.origin.x = containerView.frame.width
        case .center: break
        }
        
        return (start: startFrame, end: finalFrame)
    }
    
}

// MARK: - UIViewControllerAnimatedTransitioning Delegate

extension DirectionalAnimationController: UIViewControllerAnimatedTransitioning {
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.transitionDuration
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch transitionStyle {
        case .present:
            present(transitionContext: transitionContext)
        case .dismiss:
            dismiss(transitionContext: transitionContext)
        }
    }
    
}
