import UIKit

/// The main navigation controller for the application.
public class MainNavigationController: UINavigationController {
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        addDidChangeThemeObserver()
        updateColors(for: theme)
    }
    
    deinit {
        removeDidChangeThemeObserver()
    }
    
    override public var preferredStatusBarStyle: UIStatusBarStyle {
        switch theme {
        case .light:
            if #available(iOS 13.0, *) {
                return .darkContent
            } else {
                return .default
            }
        case .dark:
            return .lightContent
        }
    }
}

// MARK: - Themeable

extension MainNavigationController: Themeable {
    public func updateColors(for theme: Theme) {
        navigationBar.isTranslucent = false
        navigationBar.barTintColor = .background(for: theme)
        switch theme {
        case .light:
            navigationBar.shadowImage = UIColor.border(for: theme).lighter(amount: 0.1).asImage()
        case .dark:
            navigationBar.shadowImage = UIColor.border(for: theme).darker(amount: 0.1).asImage()
        }
        navigationBar.setBackgroundImage(UIColor.background(for: theme).asImage(), for: .default)
        navigationBar.tintColor = .primaryGrayScale(for: theme)
        navigationBar.backgroundColor = .background(for: theme)
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.primaryText(for: theme)]
    }
}
