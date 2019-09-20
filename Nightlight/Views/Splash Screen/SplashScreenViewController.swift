import UIKit

/// A container view controller for transitioning from the splash screen to a view controller.
public class SplashScreenViewController: UIViewController {

    /// The view that is displayed before the initial view controller.
    private let animatedLogoView = AnimatedLogoView()
    
    /// The view controller that displays after the splash screen.
    public var initialViewController: UIViewController? {
        willSet {
            guard let viewController = newValue else {
                initialViewController?.remove()
                return
            }
            
            if initialViewController != nil {
                initialViewController?.remove()
            }
            
            addChild(viewController)
            viewController.view.frame = view.frame
            viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            view.insertSubview(viewController.view, at: 0)
            viewController.didMove(toParent: self)
        }
        
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()

        prepareSubviews()
        animatedLogoView.startAnimation()
    }
    
    /**
     Stop showing the splash screen and display the initial view controller.
     */
    public func showInitialViewController() {
        animatedLogoView.endAnimation { [weak self] _ in
            self?.animatedLogoView.removeFromSuperview()
        }
    }

    private func prepareSubviews() {
        view.addSubviews(animatedLogoView)
        
        NSLayoutConstraint.activate([
            animatedLogoView.topAnchor.constraint(equalTo: view.topAnchor),
            animatedLogoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            animatedLogoView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            animatedLogoView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    public override var childForStatusBarStyle: UIViewController? {
        return initialViewController
    }
}
