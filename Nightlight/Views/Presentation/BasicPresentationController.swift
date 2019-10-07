import UIKit

public class BasicPresentationController: UIPresentationController {

    /// The presentable view controller.
    private var presentable: CustomPresentable.PresentableViewController? {
        return presentedViewController as? CustomPresentable.PresentableViewController
    }
    
    /// A background view behind the presented view controller.
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
    
    public override var frameOfPresentedViewInContainerView: CGRect {
        return presentable?.targetFrame ?? .zero
    }
    
    public override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
    
    public override func presentationTransitionWillBegin() {
        guard let containerView = containerView else { return }
        
        layoutBackgroundView(in: containerView)
        layoutPresentedView(in: containerView)
        
        guard presentable?.backgroundAlpha != 0 else { return }
        
        guard let coordinator = presentingViewController.transitionCoordinator else {
            backgroundView.dimState = .percent(presentable?.backgroundAlpha ?? 1.0)
            return
        }
        
        coordinator.animate(alongsideTransition: { [weak self] _ in
            self?.backgroundView.dimState = .percent(self?.presentable?.backgroundAlpha ?? 1.0)
            self?.presentedViewController.setNeedsStatusBarAppearanceUpdate()
        })
    }
    
    public override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        
        guard let coordinator = presentedViewController.transitionCoordinator else {
            backgroundView.dimState = .off
            return
        }
        
        coordinator.animate(alongsideTransition: { [weak self] _ in
            self?.backgroundView.dimState = .off
            self?.presentingViewController.setNeedsStatusBarAppearanceUpdate()
        })
    }
    
    func dismissPresentedViewController() {
        presentedViewController.dismiss(animated: true)
    }
}

// MARK: - Presentation Layout

extension BasicPresentationController {
    /**
     Adds and configures the presented view in the view hierarchy.
     
     - parameter view: A container view for the transition.
     */
    func layoutPresentedView(in view: UIView) {
        presentedViewController.view.layer.cornerRadius = presentable?.cornerRadius ?? 4.0
        presentedViewController.view.clipsToBounds = true
        view.addSubview(presentedViewController.view)
    }
    
    /**
     Adds and configures the background view in the view hierarchy.
     
     - parameter view: A container view for the transition.
     */
    func layoutBackgroundView(in view: UIView) {
        view.addSubviews(backgroundView)

        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
