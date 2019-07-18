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
    
    static var noResults: EmptyViewDescription {
        return EmptyViewDescription(title: "No Users Found", subtitle: "Try searching for someone else", imageName: "empty_results")
    }
    
    static var noLoad: EmptyViewDescription {
        return EmptyViewDescription(title: "No Connection", subtitle: "Failed to load.", imageName: "no_load")
    }
}
