import UIKit

extension UINavigationController {
    public enum Style {
        case primary
        case secondary
        case hidden
    }
    
    public func setStyle(_ style: Style, for theme: Theme = .system) {
        if theme == .system {
            navigationBar.shadowImage = nil
        } else {
            switch theme {
            case .dark:
                navigationBar.shadowImage = UIColor.border(for: theme).darker(amount: 0.1).asImage()
            default:
                navigationBar.shadowImage = UIColor.border(for: theme).lighter(amount: 0.1).asImage()
            }
        }

        switch style {
        case .primary:
            navigationBar.isTranslucent = false
            navigationBar.barTintColor = .background(for: theme)
            view.backgroundColor = .background(for: theme)
        case .secondary:
            navigationBar.isTranslucent = false
            navigationBar.barTintColor = .secondaryBackground(for: theme)
            view.backgroundColor = .secondaryBackground(for: theme)
        case .hidden:
            navigationBar.isTranslucent = true
            navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationBar.barTintColor = nil
            navigationBar.shadowImage = UIImage()
        }
        
        navigationBar.tintColor = .invertedBackground(for: theme)
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.primaryText(for: theme)]
    }
}
