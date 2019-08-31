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
    
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if #available(iOS 13, *), traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            if theme == .system {
                updateColors(for: theme)
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

extension MainNavigationController: Themeable {
    public func updateColors(for theme: Theme) {
//        if theme != .system {
//            navigationBar.isTranslucent = false
//            navigationBar.barTintColor = .background(for: theme)
//            switch theme {
//            case .dark:
//                navigationBar.shadowImage = UIColor.border(for: theme).darker(amount: 0.1).asImage()
//            default:
//                navigationBar.shadowImage = UIColor.border(for: theme).lighter(amount: 0.1).asImage()
//            }
//            navigationBar.setBackgroundImage(UIColor.background(for: theme).asImage(), for: .default)
//            navigationBar.backgroundColor = .background(for: theme)
//        } else {
//            if navigationBar.barTintColor != .clear {
//                navigationBar.setBackgroundImage(nil, for: .default)
//                navigationBar.barTintColor = nil
//                navigationBar.backgroundColor = nil
//                navigationBar.shadowImage = nil
//                navigationBar.isTranslucent = true
//            }
//        }
//
//        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.primaryText(for: theme)]
//        navigationBar.tintColor = .invertedBackground(for: theme)
    }
}
