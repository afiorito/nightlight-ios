import UIKit

/// The object responsible for coordinating a modal view controller transition.
public class ModalAnimator: NSObject {
    /// A constant for representing the transition style.
    public enum TransitionStyle {
        case present
        case dismiss
    }
    
    /// The default duration of the animation.
    static let defaultDuration: TimeInterval = 0.35
    
    /// The transition style of the animation.
    private let transitionStyle: TransitionStyle
    
    required public init(transitionStyle: TransitionStyle) {
        self.transitionStyle = transitionStyle
        super.init()
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
        
        let modal: UIView = toViewController.view
        modal.alpha = 0

        animate({
            modal.alpha = 1
        }, config: presentable, completion: { completed in
            fromViewController.endAppearanceTransition()
            toViewController.endAppearanceTransition()
            transitionContext.completeTransition(completed)
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
        let modal: UIView = fromViewController.view
        
        animate({
            modal.alpha = 0
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
    private func animate(_ animations: @escaping ModalPresentable.AnimationBlockType, config: ModalPresentable?, completion: ModalPresentable.AnimationCompletionType? = nil) {
        
        let transitionDuration = config?.transitionDuration ?? Self.defaultDuration
        let animationOptions = config?.animationOptions ?? [.curveEaseIn]
        
        UIView.animate(withDuration: transitionDuration,
                       delay: 0,
                       options: animationOptions,
                       animations: animations,
                       completion: completion)
    }
    
    /**
     Returns the appropriate presentable view controller for a specified transition context.
     
     - parameter context: the context object containing information to use during the transition.
     */
    private func presentableViewController(from context: UIViewControllerContextTransitioning) -> ModalPresentable.Presentable? {
        let viewController: UIViewController?
        
        switch transitionStyle {
        case .present:
            viewController = context.viewController(forKey: .to)
        case .dismiss:
            viewController = context.viewController(forKey: .from)
        }
        
        return viewController as? ModalPresentable.Presentable
    }
    
}

// MARK: - UIViewControllerAnimatedTransitioning Delegate

extension ModalAnimator: UIViewControllerAnimatedTransitioning {
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
