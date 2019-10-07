/// A constant for denoting a shortcut item identifier.
public enum ShortcutIdentifier: String {
    case RecentMessages
    case HelpfulPeople
    case NewMessage
    
    init?(identifier: String) {
        guard let key = identifier.components(separatedBy: ".").last else { return nil }
        
        self.init(rawValue: key)
    }
}
