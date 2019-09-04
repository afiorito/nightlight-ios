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
