import UIKit

/// Notification for broadcasting theme changes.
enum NLNotification: String {
    
    /// A notification indicating that the app's color theme has changed.
    case didChangeTheme
    
    /**
     Broadcasts a global notification.
 
     - parameter notificationCenter: The mechanism for broadcasting information throughout the app.
     - parameter object: The object posting the notification.
     - parameter userInfo: Information about the the notification.
     */
    func post(notificationCenter: NotificationCenter = NotificationCenter.default, object: AnyObject? = nil, userInfo: Any) {
        let userInfo = [self.rawValue: userInfo]
        DispatchQueue.main.async {
            notificationCenter.post(name: Notification.Name(rawValue: self.rawValue), object: object, userInfo: userInfo)
        }
    }
    
    /**
     Observes a global notification using a provided method.

     - parameter notificationCenter: The mechanism for broadcasting information throughout the app.
     - parameter target: The object on which to call the `selector` method.
     - parameter selector: The method to call when the notification is broadcast.
     */
    func observe(notificationCenter: NotificationCenter = NotificationCenter.default, target: AnyObject, selector: Selector) {
        notificationCenter.addObserver(target, selector: selector, name: Notification.Name(rawValue: self.rawValue), object: nil)
    }
}
