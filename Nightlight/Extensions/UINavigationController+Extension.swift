import UIKit

extension UINavigationController {
    public enum Style {
        case primary
        case secondary
        case hidden
    }
    
    /**
     Set the style of the navigation bar for a specified theme.
     
     - parameter style: The style of the navigation bar.
     - parameter theme: The theme for the style.
     */
    public func setStyle(_ style: Style, for theme: Theme = .system) {
        switch theme {
        case .dark:
            navigationBar.barStyle = .blackOpaque
        default:
            navigationBar.barStyle = .default
        }

        switch style {
        case .primary:
            navigationBar.isTranslucent = false
            navigationBar.barTintColor = .background(for: theme)
            view.backgroundColor = .background(for: theme)
            navigationBar.shadowImage = UIColor.secondaryLabel(for: theme).withAlphaComponent(0.3).asImage(with: CGSize(width: 1, height: 1 / UIScreen.main.scale))
            navigationBar.setBackgroundImage(nil, for: .default)
        case .secondary:
            navigationBar.isTranslucent = false
            navigationBar.barTintColor = .secondaryBackground(for: theme)
            view.backgroundColor = .secondaryBackground(for: theme)
            navigationBar.shadowImage = UIColor.secondaryLabel(for: theme).withAlphaComponent(0.3).asImage(with: CGSize(width: 1, height: 1 / UIScreen.main.scale))
            navigationBar.setBackgroundImage(nil, for: .default)
        case .hidden:
            navigationBar.isTranslucent = true
            navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationBar.barTintColor = nil
            navigationBar.shadowImage = UIColor.clear.asImage()
        }
        
        navigationBar.tintColor = .label(for: theme)
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.label(for: theme)]
    }
}
