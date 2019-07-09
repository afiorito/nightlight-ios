import UIKit

public class SplashScreenViewController: UIViewController {

    private let animatedLogoView = AnimatedLogoView()
    
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
            view.insertSubview(viewController.view, at: 0)
            viewController.didMove(toParent: self)
        }
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()

        prepareSubviews()
        animatedLogoView.startAnimation()
    }
    
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
}
