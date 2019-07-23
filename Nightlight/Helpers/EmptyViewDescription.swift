import UIKit

/// A description of the placeholder for empty content.
public struct EmptyViewDescription {
    public var title: String
    public var subtitle: String
    public var imageName: String
}

public extension EmptyViewDescription {
    static var noRecentMessages: EmptyViewDescription {
        return EmptyViewDescription(title: "No Recent Messages", subtitle: "Tap the + to send one", imageName: "empty_message")
    }
    
    static var noReceivedMessages: EmptyViewDescription {
        return EmptyViewDescription(title: "No Received Messages",
                                    subtitle: "When someone sends you a message, you will see it here.",
                                    imageName: "empty_message")
    }
    
    static var noSentMessages: EmptyViewDescription {
        return EmptyViewDescription(title: "No Sent Messages", subtitle: "Tap the + to send one", imageName: "empty_message")
    }
    
    static var noSavedMessages: EmptyViewDescription {
        return EmptyViewDescription(title: "No Saved Messages", subtitle: "Your saved messages will show up here.", imageName: "empty_message")
    }
    
    static var noResults: EmptyViewDescription {
        return EmptyViewDescription(title: "No Users Found", subtitle: "Try searching for someone else", imageName: "empty_results")
    }
    
    static var noNotifications: EmptyViewDescription {
            return EmptyViewDescription(
                title: "No Notifications",
                subtitle: "You will get notified when someone engages with your content.",
                imageName: "empty_notifications")
        }
    
    static var noLoad: EmptyViewDescription {
        return EmptyViewDescription(title: "No Connection", subtitle: "Failed to load.", imageName: "no_load")
    }
}
