import UIKit

public class BottomSheetPresentationController: UIPresentationController {
    
    private var yPos: CGFloat = 0
    
    private var presentable: BottomSheetPresentable? {
        return presentedViewController as? BottomSheetPresentable
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
    
    public override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        
        configurePresentation()
    }
    
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
    
    public override func dismissalTransitionWillBegin() {
        guard let coordinator = presentedViewController.transitionCoordinator else {
            backgroundView.dimState = .off
            return
        }
        
        coordinator.animate(alongsideTransition: { [weak self] _ in
            self?.backgroundView.dimState = .off
            self?.presentingViewController.setNeedsStatusBarAppearanceUpdate()
        })
    }
    
    private func configurePresentation() {
        guard let presentableViewController = presentedViewController as? BottomSheetPresentable.Presentable
            else { return }
        
        yPos = presentableViewController.yPos
        
    }
    
    func dismissPresentedViewController() {
        presentedViewController.dismiss(animated: true)
    }
}

// MARK: - Layout Configuration

private extension BottomSheetPresentationController {
    func layoutPresentedView(in containerView: UIView) {
        containerView.addSubview(presentedViewController.view)
        addRoundedCorners(to: presentedViewController.view)
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

private extension BottomSheetPresentationController {
    func addRoundedCorners(to view: UIView) {
        let radius = presentable?.cornerRadius ?? 0
        let path = UIBezierPath(roundedRect: view.bounds,
                                byRoundingCorners: [.topLeft, .topRight],
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
