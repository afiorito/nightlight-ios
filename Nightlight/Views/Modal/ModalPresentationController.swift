import UIKit

/// An object for coordinating between the presenting & presented view controllers.
public class ModalPresentationController: UIPresentationController {
    /// The delegate for receiving transition events.
    public weak var presentationDelegate: ModalPresentationControllerDelegate?
    
    /**
     The configuration object.
     */
    private var presentable: ModalPresentable.Presentable? {
        return presentedViewController as? ModalPresentable.Presentable
    }
    
    /**
     A background view behind the bottom sheet.
     */
    private lazy var backgroundView: DimmedView = {
        let view: DimmedView
        if let alpha = presentable?.backgroundAlpha {
            view = DimmedView(dimAlpha: alpha)
        } else {
            view = DimmedView()
        }
        view.didTap = { [weak self] in
            self?.dismissPresentedViewController()
        }
        return view
    }()
    
    // MARK: - Presentation Lifecycle
    
    public override func presentationTransitionWillBegin() {
        guard let containerView = containerView else { return }
        
        layoutBackgroundView(in: containerView)
        layoutPresentedView(in: containerView)
        
        guard let coordinator = presentedViewController.transitionCoordinator else {
            backgroundView.dimState = .max
            return
        }
        
        coordinator.animate(alongsideTransition: { [weak self] _ in
            self?.backgroundView.dimState = .max
            self?.presentedViewController.setNeedsStatusBarAppearanceUpdate()
        })
    }

    public override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()

        presentedView?.frame = frameOfPresentedViewInContainerView
        
        if presentedViewController.view.layer.mask == .none {
            addRoundedCorners(to: presentedViewController.view)
        }
    }
    
    public override func dismissalTransitionWillBegin() {
        presentationDelegate?.modalPresentationControllerWillDimiss?(self)
        guard let coordinator = presentedViewController.transitionCoordinator else {
            backgroundView.dimState = .off
            return
        }
        
        coordinator.animate(alongsideTransition: { [weak self] _ in
            self?.backgroundView.dimState = .off
            self?.presentingViewController.setNeedsStatusBarAppearanceUpdate()
        })
    }
    
    public override func dismissalTransitionDidEnd(_ completed: Bool) {
        presentationDelegate?.modalPresentationController?(self, didDismiss: true)
    }
    
    func dismissPresentedViewController() {
        presentedViewController.dismiss(animated: true)
    }
    
    public override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else { return . zero }

        let targetSize = presentable?.targetSize ?? .zero
        let x = (containerView.frame.width - targetSize.width) / 2
        let y = containerView.frame.midY - targetSize.height / 2

        return CGRect(origin: CGPoint(x: x, y: y), size: targetSize)
    }
}

// MARK: - Layout Configuration

private extension ModalPresentationController {
    /**
     Adds and configures the presented view in the view hierarchy.
     
     - parameter containerView: the container view for the transition.
     */
    func layoutPresentedView(in containerView: UIView) {
        containerView.addSubview(presentedViewController.view)
    }

    /**
     Adds and configures the background view in the view hierarchy.
     
     - parameter containerView: the container view for the transition.
     */
    func layoutBackgroundView(in containerView: UIView) {
        containerView.addSubviews(backgroundView)

        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: containerView.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }
}

// MARK: - UIBezierPath

private extension ModalPresentationController {
    /**
     Draws top rounded corners on a given view.
     */
    func addRoundedCorners(to view: UIView) {
        let radius = presentable?.cornerRadius ?? 0
        let path = UIBezierPath(roundedRect: view.bounds,
                                byRoundingCorners: [.allCorners],
                                cornerRadii: CGSize(width: radius, height: radius))
        
        // Set path as a mask to display optional drag indicator view & rounded corners
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        view.layer.mask = mask
        
        // Improve performance by rasterizing the layer
        view.layer.shouldRasterize = true
        view.layer.rasterizationScale = UIScreen.main.scale
    }
    
}
