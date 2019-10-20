import UIKit

public class EdgeAnimation: UIPercentDrivenInteractiveTransition {
    /// A constant denoting where the presented view appears from.
    public enum Edge {
        case bottom, top
        case left, right
        case center
    }
    
    /// A generator for announcing that the presented view has appeared.
    private var feedbackGenerator: UISelectionFeedbackGenerator?
    
    /// The initial alpha of the view for the presentation.
    public var initialAlpha: CGFloat = 1.0
    
    /// A boolean denoting if the beginning of the animation has haptic feedback.
    public var hasHapticFeedback = false

    /// The duration of the transition animation.
    ///
    /// If a spring timing parameter is used, the duration of the animation is determined by
    /// the solution to the spring equation.
    public var transitionDuration: TimeInterval = 0.5

    /// The spring damping constant for the presentation.
    public var timingParameters: ((_ initialVelocity: CGVector) -> UITimingCurveProvider)?
    
    /// The threshold for dismissing the presented view interactively.
    public var completionThreshold: CGFloat = 0.5
    
    /// The edge the presented view appears from.
    public let edge: Edge
    
    /// The operation performed by the transition.
    public var operation: UIViewController.Operation = .none
    
    /// The animator driven the percentage driven interactive transition.
    public var transitionAnimator: UIViewPropertyAnimator?
    
    /// The presented view controller.
    public weak var targetViewController: UIViewController? {
        didSet {
            if let viewController = targetViewController {
                preparePanGestureRecognizer(in: viewController.view)
            }
        }
    }
    
    /// A boolean denoting if the transition is being driven interactivelly.
    private(set) var isInteractive = false
    
    /// The transition context for the transition.
    private var transitionContext: UIViewControllerContextTransitioning!
    
    /// The animator for driving the frame animations of the presented view controller.
    private var frameAnimator: UIViewPropertyAnimator?
    
    /// A pan gesture recognizer for initiating and managing the interactive transition.
    private var panGestureRecognizer: UIPanGestureRecognizer?
    
    init(_ edge: Edge) {
        self.edge = edge
    }
    
    /**
     Prepare the pan gesture recognizer in the specified view.
     
     - parameter view: The view to prepare the pan gesture in.
     */
    private func preparePanGestureRecognizer(in view: UIView) {
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(updateAnimationInteractively))
        view.addGestureRecognizer(gestureRecognizer)
        
        self.panGestureRecognizer = gestureRecognizer
    }
    
    /**
     Handle the interactive transition using a pan gesture.
     
     - parameter gesture: The pan gesture of the transition.
     */
    @objc private func updateAnimationInteractively(_ gesture: UIPanGestureRecognizer) {
        if gesture.state == .began && transitionAnimator == nil {
            isInteractive = true
            targetViewController?.dismiss(animated: true)
            return
        }
        
        guard let targetViewController = targetViewController else {
            return endInteraction()
        }
        
        switch gesture.state {
        case .began:
            pauseInteraction()
        case .changed:
            let translation = gesture.translation(in: transitionContext.containerView)
            targetViewController.view.frame.origin = newOrigin(targetViewController.view.frame.origin, for: translation)
            
            update(newProgress(totalLength: targetViewController.view.frame.height, translation: translation))
            
            gesture.setTranslation(.zero, in: transitionContext.containerView)
        case .ended, .cancelled:
            endInteraction()
        default: break
        }
    }
    
    /**
     Animates the presented view controller to the specified position.
     
     - parameter position: The target position to animate the presented view controller to.
     */
    private func animate(to position: UIViewAnimatingPosition) {
        let frameAnimator = propertyAnimator(initialVelocity: timingCurveVelocity(for: position))
        
        guard let targetViewController = targetViewController else {
            transitionContext.completeTransition(true)
            return
        }

        let (initialFrame, finalFrame) = targetFrame
        
        frameAnimator.addAnimations {
            targetViewController.view.frame = position == .end ? finalFrame : initialFrame
        }

        self.frameAnimator = frameAnimator
        
        let transitionAnimator = interruptibleAnimator(using: transitionContext) as! UIViewPropertyAnimator
        
        if transitionAnimator.state == .inactive {
            feedbackGenerator?.selectionChanged()
            targetViewController.view.frame = initialFrame
            transitionAnimator.startAnimation()
        } else {
            completionSpeed = CGFloat(frameAnimator.duration / transitionAnimator.duration)
        }
        
        frameAnimator.startAnimation()
    }
    
    /**
     Pause the active transition and animators.
     */
    private func pauseInteraction() {
        frameAnimator?.stopAnimation(true)
        pause()
    }
    
    /**
     Complete the interactive transition.
     */
    private func endInteraction() {
        animate(to: completionPosition)
        
        if completionPosition == .end {
            finish()
        } else {
            cancel()
        }

    }
    
    /// The final position of the presented view controller.
    private var completionPosition: UIViewAnimatingPosition {
        func slowEnd() -> UIViewAnimatingPosition {
            if percentComplete >= completionThreshold {
                return .end
            } else {
                return .start
            }
        }
        
        guard let gesture = panGestureRecognizer else {
            return slowEnd()
        }
        
        let view = transitionContext.containerView
        
        switch edge {
        case .bottom:
            if gesture.isFlickDown(in: view) {
                return .end
            } else if gesture.isFlickUp(in: view) {
                return .start
            }
        case .top:
            if gesture.isFlickUp(in: view) {
                return .end
            } else if gesture.isFlickDown(in: view) {
                return .start
            }
        case  .left:
            if gesture.isFlickLeft(in: view) {
                return .end
            } else if gesture.isFlickRight(in: view) {
                return .start
            }
        case .right:
            if gesture.isFlickRight(in: view) {
                return .end
            } else if gesture.isFlickLeft(in: view) {
                return .start
            }
        case .center: break
        }
        
        return slowEnd()
    }
    
    /**
     The new origin of the presented view controller after a gesture translation.
     
     - parameter origin: The current origin of the presented view controller.
     - parameter translation: The translation of the gesture.
     */
    private func newOrigin(_ origin: CGPoint, for translation: CGPoint) -> CGPoint {
        let newOrigin = origin + translation
        
        switch edge {
        case .bottom: return CGPoint(x: origin.x, y: max(newOrigin.y, targetFrame.initial.minY))
        case .top: return CGPoint(x: origin.x, y: min(newOrigin.y, targetFrame.initial.minY))
        case  .left: return CGPoint(x: min(newOrigin.x, targetFrame.initial.minX), y: origin.y)
        case .right: return CGPoint(x: max(newOrigin.x, targetFrame.initial.minX), y: origin.y)
        case .center: break
        }
        
        return origin
    }
    
    /**
     The new completion percentage of the transition
     
     - parameter totalLength: The total length possible translation length.
     - parameter translation: The translation of the gesture.
     */
    private func newProgress(totalLength: CGFloat, translation: CGPoint) -> CGFloat {
        var progress: CGFloat = 0.0

        switch edge {
        case .bottom: progress = translation.y / totalLength
        case .top: progress = -translation.y / totalLength
        case  .left: progress = -translation.x / totalLength
        case .right: progress = translation.x / totalLength
        case .center: break
        }
        
        return clip(0.0, 1.0, percentComplete + progress)
    }
    
    /**
     The initial and final positions of the presented view controller.
     */
    private var targetFrame: (initial: CGRect, final: CGRect) {
        guard let viewController = targetViewController else { return (.zero, .zero) }

        let containerView = transitionContext.containerView
        let finalFrame = transitionContext.finalFrame(for: viewController)
        var startFrame = finalFrame
        
        switch edge {
        case .bottom: startFrame.origin.y = containerView.frame.height
        case .top: startFrame.origin.y = -startFrame.height
        case  .left: startFrame.origin.x = -startFrame.width
        case .right: startFrame.origin.x = containerView.frame.width
        case .center: break
        }
        
        if operation == .present {
            return (initial: startFrame, final: finalFrame)
        } else {
            return (initial: finalFrame, final: startFrame)
        }
    }
    
    /**
     Performs initial setup for the transition.
     */
    private func prepareForTransition(using transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        
        if operation == .present && hasHapticFeedback {
            feedbackGenerator = UISelectionFeedbackGenerator()
            feedbackGenerator?.prepare()
        }
        
        transitionContext.viewController(forKey: .from)?.beginAppearanceTransition(false, animated: true)
        transitionContext.viewController(forKey: .to)?.beginAppearanceTransition(true, animated: true)
    }
    
    /**
     Converts the gesture velocity to an appropriate timing curve velocity.
     
     - parameter position: The target position of the presented view controller.
     */
    private func timingCurveVelocity(for position: UIViewAnimatingPosition) -> CGVector {
        guard let velocity = panGestureRecognizer?.velocity(in: transitionContext.containerView),
            let targetViewController = targetViewController
            else { return .zero }
        
        let (initialFrame, finalFrame) = self.targetFrame
        let targetFrame = position == .end ? finalFrame : initialFrame
        
        let dx = abs(targetFrame.midX - targetViewController.view.frame.midX)
        let dy = abs(targetFrame.midY - targetViewController.view.frame.midY)
        
        guard dx > 0.0 && dy > 0.0 else { return .zero }
        
        let range: CGFloat = 35.0
        let clippedVx = clip(-range, range, velocity.x / dx)
        let clippedVy = clip(-range, range, velocity.y / dy)
        
        return CGVector(dx: clippedVx, dy: clippedVy)
    }
    
    /**
     Returns the property animator driving the frame animation.
     
     - parameter initialVelocity: The initial velocity for the spring equation.
     */
    private func propertyAnimator(initialVelocity: CGVector = .zero) -> UIViewPropertyAnimator {
        let timingParameters: UITimingCurveProvider
        
        if let userParameters = self.timingParameters?(initialVelocity) {
            timingParameters = userParameters
        } else {
            timingParameters = UISpringTimingParameters(mass: 3.5, stiffness: 1000, damping: 90, initialVelocity: initialVelocity)
        }

        return UIViewPropertyAnimator(duration: self.transitionDuration, timingParameters: timingParameters)
    }
}

// MARK: - UIViewControllerAnimatedTransitioning

extension EdgeAnimation: UIViewControllerAnimatedTransitioning {
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return propertyAnimator().duration
    }
    
    public override func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        super.startInteractiveTransition(transitionContext)
        prepareForTransition(using: transitionContext)
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        prepareForTransition(using: transitionContext)
        animate(to: .end)
    }
    
    public func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        if let interruptibleAnimator = transitionAnimator {
            return interruptibleAnimator
        }
        
        let dummyView = UIView()
        transitionContext.containerView.addSubview(dummyView)
        
        let animator = UIViewPropertyAnimator(duration: propertyAnimator().duration, curve: .easeOut, animations: {
            dummyView.alpha = 0.0
        })
        
        animator.addCompletion { position in
            transitionContext.viewController(forKey: .from)?.endAppearanceTransition()
            transitionContext.viewController(forKey: .to)?.endAppearanceTransition()
            let completed = (position == .end)
            transitionContext.completeTransition(completed)
        }
        
        self.transitionAnimator = animator
        
        return animator
    }
    
    public func animationEnded(_ transitionCompleted: Bool) {
        isInteractive = false
        transitionAnimator = nil
        frameAnimator = nil
        feedbackGenerator = nil
    }
}
