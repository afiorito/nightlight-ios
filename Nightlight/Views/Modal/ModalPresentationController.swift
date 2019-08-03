import UIKit

public class ModalPresentationController: UIPresentationController {
    
    public weak var presentationDelegate: ModalPresentationControllerDelegate?
    
    private var presentable: ModalPresentable? {
        return presentedViewController as? ModalPresentable
    }
    
    private lazy var backgroundView: DimmedView = {
        let view: DimmedView
        if let alpha = presentable?.backgroundAlpha {
            view = DimmedView(dimAlpha: alpha)
        } else {
            view = DimmedView()
        }
        view.didTap = { [weak self] _ in
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
    
    public override func presentationTransitionDidEnd(_ completed: Bool) {
        
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
}

// MARK: - Layout Configuration

private extension ModalPresentationController {
    func layoutPresentedView(in containerView: UIView) {
        guard let presentableViewController = presentedViewController as? ModalPresentable.Presentable
            else { return }
        
        let margins = presentableViewController.sideMargins
        
        let view: UIView = presentableViewController.view
        view.frame = view.frame.inset(by: UIEdgeInsets(top: 0, left: margins, bottom: 0, right: margins))
        
        containerView.addSubview(view)
        addRoundedCorners(to: presentedViewController.view, ofSize: presentableViewController.targetSize)
    }

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
    func addRoundedCorners(to view: UIView, ofSize size: CGSize) {
        let radius = presentable?.cornerRadius ?? 0
        let path = UIBezierPath(roundedRect: CGRect(origin: .zero, size: size),
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
