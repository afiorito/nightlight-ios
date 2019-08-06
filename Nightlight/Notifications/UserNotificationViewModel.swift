import UIKit

public class UserNotificationViewModel {
    
    private let userNotification: AnyUserNotification
    
    public var icon: UIImage? {
        switch NotificationType(rawValue: userNotification.type) {
        case .loveMessage:
            return UIImage(named: "heart_selected")
        case .appreciateMessage:
            return UIImage(named: "sun_selected")
        case .receiveMessage:
            return UIImage(named: "message_selected")
        default:
            return UIImage(named: "heart_selected")
        }
    }
    
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
    
    func bolded(str: String) -> NSAttributedString {
        guard let font = UIFont.secondary16ptBold else {
            return NSAttributedString(string: str)
        }

        let attributes = [NSAttributedString.Key.font: font]
        return NSAttributedString(string: str, attributes: attributes)
    }
    
    init(userNotification: AnyUserNotification) {
        self.userNotification = userNotification
    }
    
}
