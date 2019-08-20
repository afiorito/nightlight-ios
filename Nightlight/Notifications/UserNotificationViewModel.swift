import UIKit

/// A view model for handling a user notification.
public class UserNotificationViewModel {
    
    /// The backing user notification model.
    private let userNotification: AnyUserNotification
    
    /// The icon of the notification.
    public var icon: UIImage? {
        switch NotificationType(rawValue: userNotification.type) {
        case .loveMessage:
            return UIImage.icon.heartSelected
        case .appreciateMessage:
            return UIImage.icon.sunSelected
        case .receiveMessage:
            return UIImage.icon.messageSelected
        default:
            return UIImage.icon.heartSelected
        }
    }
    
    /// The body of the notification.
    public var body: NSAttributedString {
        let bodyString = NSMutableAttributedString()
        
        switch userNotification.data {
        case let data as OneTimeNotificationData:
            bodyString.append(NSAttributedString(string: "Received a message from "))
            bodyString.append(bolded(str: data.username))
        case let data as IncrementalNotificationData:
            let action: String
            let noun = data.count == 1 ? "person" : "people"

            switch NotificationType(rawValue: userNotification.type) {
            case .appreciateMessage:
                action = "appreciated"
            default:
                action = "loved"
            }
            
            bodyString.append(bolded(str: "\(data.count.abbreviated) \(noun)"))
            bodyString.append(NSAttributedString(string: " \(action) your message "))
            bodyString.append(bolded(str: "\"\(data.title)\""))
        default:
            break
        }
        
        bodyString.append(NSAttributedString(string: "."))
        
        return bodyString
    }
    
    init(userNotification: AnyUserNotification) {
        self.userNotification = userNotification
    }
    
    /**
     Helper for bolding certain sections of notification body.
     */
    private func bolded(str: String) -> NSAttributedString {
        guard let font = UIFont.secondary16ptBold else {
            return NSAttributedString(string: str)
        }

        let attributes = [NSAttributedString.Key.font: font]
        return NSAttributedString(string: str, attributes: attributes)
    }
    
}
