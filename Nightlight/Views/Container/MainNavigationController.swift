import UIKit

/// The main navigation controller for the application.
public class MainNavigationController: UINavigationController {
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        addDidChangeThemeObserver()
    }
    
    deinit {
        removeDidChangeThemeObserver()
    }
    
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if #available(iOS 13, *), traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            if !navigationBar.isTranslucent {
                navigationBar.shadowImage = UIColor.secondaryLabel(for: theme).withAlphaComponent(0.3).asImage(with: CGSize(width: 1, height: 1 / UIScreen.main.scale))
            }
        }
    }
    
    override public var preferredStatusBarStyle: UIStatusBarStyle {
        switch theme {
        case .dark:
            return .lightContent
        case .light:
            if #available(iOS 13.0, *) {
                return .darkContent
            } else {
                return .default
            }
        case .system:
            return .default
        }
    }
}

// MARK: - Themeable

extension MainNavigationController: Themeable {}
