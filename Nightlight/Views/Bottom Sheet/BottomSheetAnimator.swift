import UIKit

/// The object responsible for coordinating a bottom sheet view controller transition.
public class BottomSheetAnimator: NSObject {
    /// A constant for representing the transition style.
    public enum TransitionStyle {
        case present
        case dismiss
    }
    
    /// The default duration of the animation.
    static let defaultDuration: TimeInterval = 0.5
    
    /// The transition style of the animation.
    private let transitionStyle: TransitionStyle
    
    /// A generator for announcing that the bottom sheet has appeared.
    private var feedbackGenerator: UISelectionFeedbackGenerator?
    
    required public init(transitionStyle: TransitionStyle) {
        self.transitionStyle = transitionStyle
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
        
        let presentable = presentableViewController(from: transitionContext)
        
        fromViewController.beginAppearanceTransition(false, animated: true)
        toViewController.beginAppearanceTransition(true, animated: true)
        
        let bottomSheet: UIView = toViewController.view
        bottomSheet.frame = transitionContext.finalFrame(for: toViewController)
        
        let finalYPos = bottomSheet.frame.minY
        bottomSheet.frame.origin.y = transitionContext.containerView.frame.height

        feedbackGenerator?.selectionChanged()
        
        animate({
            bottomSheet.frame.origin.y = finalYPos
        }, config: presentable, completion: { [weak self] completed in
            fromViewController.endAppearanceTransition()
            toViewController.endAppearanceTransition()
            transitionContext.completeTransition(completed)
            self?.feedbackGenerator = nil
        })
    }
    
    /**
     Executes the dismissal transition.
     
     - parameter transitionContext: the context object containing information to use during the transition.
     */
    private func dismiss(transitionContext: UIViewControllerContextTransitioning) {
        guard
            let toViewController = transitionContext.viewController(forKey: .to),
            let fromViewController = transitionContext.viewController(forKey: .from)
            else { return }
        
        fromViewController.beginAppearanceTransition(false, animated: true)
        toViewController.beginAppearanceTransition(true, animated: true)
        
        let presentable = presentableViewController(from: transitionContext)
        let bottomSheet: UIView = fromViewController.view
        
        animate({
            bottomSheet.frame.origin.y = transitionContext.containerView.frame.height
        }, config: presentable,
           completion: { completed in
            fromViewController.endAppearanceTransition()
            toViewController.endAppearanceTransition()
            transitionContext.completeTransition(completed)
        })
    }
    
    /**
     Performs the animations.
     */
    private func animate(_ animations: @escaping BottomSheetPresentable.AnimationBlockType, config: BottomSheetPresentable?, completion: BottomSheetPresentable.AnimationCompletionType? = nil) {
        
        let transitionDuration = config?.transitionDuration ?? Self.defaultDuration
        let springDamping = config?.springDamping ?? 1.0
        let animationOptions = config?.animationOptions ?? []
        
        UIView.animate(withDuration: transitionDuration,
                       delay: 0,
                       usingSpringWithDamping: springDamping,
                       initialSpringVelocity: 0,
                       options: animationOptions,
                       animations: animations,
                       completion: completion)
    }
    
    /**
     Returns the appropriate presentable view controller for a specified transition context.
     
     - parameter context: the context object containing information to use during the transition.
     */
    private func presentableViewController(from context: UIViewControllerContextTransitioning) -> BottomSheetPresentable.Presentable? {
        let viewController: UIViewController?
        
        switch transitionStyle {
        case .present:
            viewController = context.viewController(forKey: .to)
        case .dismiss:
            viewController = context.viewController(forKey: .from)
        }
        
        return viewController as? BottomSheetPresentable.Presentable
    }
    
}

// MARK: - UIViewControllerAnimatedTransitioning Delegate

extension BottomSheetAnimator: UIViewControllerAnimatedTransitioning {
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        
        guard
            let context = transitionContext,
            let presentable = presentableViewController(from: context)
            else { return Self.defaultDuration }
        
        return presentable.transitionDuration
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
