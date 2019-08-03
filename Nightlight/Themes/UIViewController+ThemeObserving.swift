import UIKit

extension UIViewController: ThemeObserving {
    func addDidChangeThemeObserver(notificationCenter: NotificationCenter = NotificationCenter.default) {
        notificationCenter.addObserver(
            self,
            selector: #selector(didChangeTheme),
            name: Notification.Name(rawValue: NLNotification.didChangeTheme.rawValue),
            object: nil
        )
    }
    
    func removeDidChangeThemeObserver(notificationCenter: NotificationCenter = NotificationCenter.default) {
        notificationCenter.removeObserver(
            self,
            name: Notification.Name(rawValue: NLNotification.didChangeTheme.rawValue),
            object: nil
        )
    }
    
    @objc func didChangeTheme(_ notification: Notification) {
        updateColors(from: notification)
    }
}
