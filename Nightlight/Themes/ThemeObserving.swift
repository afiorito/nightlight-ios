import UIKit

/// A protocol for observing theme changes through notifications. Call `addDidChangeThemeObserver` upon instantiation and `removeDidChangeThemeObserver` upon deinit to adapt to the app's color theme setting.
protocol ThemeObserving {
    /**
     Start observing color change notifications.
     
     - parameter notificationCenter: The mechanism for broadcasting color theme change information throughout the program.
     */
    func addDidChangeThemeObserver(notificationCenter: NotificationCenter)
    
    /**
     Stop observing color change notifications.
     
     - parameter notificationCenter: The mechanism for broadcasting color theme change information throughout the program.
     */
    func removeDidChangeThemeObserver(notificationCenter: NotificationCenter)
    
    /**
     Called whenever `didChangeTheme` notifications is received. Used to update the theme of the current ui elements.
     
     - parameter notification: The `didChangeTheme` notification.
     */
    func didChangeTheme(_ notification: Notification)
}

// MARK: - ThemeObserving

extension ThemeObserving {
    func theme(from notification: Notification) -> Theme? {
        guard let userInfo = notification.userInfo,
            let theme = userInfo[NLNotification.didChangeTheme.rawValue] as? Theme else {
            assertionFailure("Unexpected user info value type.")
            return nil
        }
        
        return theme
    }

    func updateColors(from notification: Notification) {
        guard let theme = theme(from: notification) else { return }
        
        if let themeable = self as? Themeable {
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .transitionCrossDissolve, animations: {
                themeable.updateColors(for: theme)
            }, completion: nil)
        }
    }
}
