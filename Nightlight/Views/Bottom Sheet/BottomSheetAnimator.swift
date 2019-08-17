import UIKit

public class BottomSheetAnimator: NSObject {
    public enum TransitionStyle {
        case present
        case dismiss
    }
    
    static let defaultDuration: TimeInterval = 0.5
    
    private let transitionStyle: TransitionStyle
    
    private var feedbackGenerator: UISelectionFeedbackGenerator?
    
    required public init(transitionStyle: TransitionStyle) {
        self.transitionStyle = transitionStyle
        super.init()
        
        if case .present = transitionStyle {
            feedbackGenerator = UISelectionFeedbackGenerator()
            feedbackGenerator?.prepare()
        }
    }
    
    private func present(transitionContext: UIViewControllerContextTransitioning) {
        guard
            let toViewController = transitionContext.viewController(forKey: .to),
            let fromViewController = transitionContext.viewController(forKey: .from)
            else { return }
        
        let presentable = presentableViewController(from: transitionContext)
        
        fromViewController.beginAppearanceTransition(false, animated: true)
        toViewController.beginAppearanceTransition(true, animated: true)
        
        let yPos = presentable?.yPos ?? 0.0
        
        let bottomSheet: UIView = toViewController.view
        
        bottomSheet.frame = transitionContext.finalFrame(for: toViewController)
        bottomSheet.frame.size.height = transitionContext.containerView.frame.height - yPos
        bottomSheet.frame.origin.y = transitionContext.containerView.frame.height
        
        feedbackGenerator?.selectionChanged()
        
        animate({
            bottomSheet.frame.origin.y = yPos
        }, config: presentable, completion: { [weak self] completed in
            fromViewController.endAppearanceTransition()
            toViewController.endAppearanceTransition()
            transitionContext.completeTransition(completed)
            self?.feedbackGenerator = nil
        })
    }
    
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
