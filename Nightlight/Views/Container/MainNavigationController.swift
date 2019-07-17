import UIKit

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
        navigationBar.shadowImage = UIColor.border(for: theme).asImage()
        navigationBar.tintColor = .primaryGrayScale(for: theme)
    }
}
