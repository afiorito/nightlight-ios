import UIKit

/// A description of the placeholder for empty content.
public struct EmptyViewDescription {
    public var title: String
    public var subtitle: String
    public var image: UIImage?
}

public extension EmptyViewDescription {
    static var noRecentMessages: EmptyViewDescription {
        return EmptyViewDescription(title: "No Recent Messages", subtitle: "Tap the + to send one", image: UIImage(named: "empty_message_light"))
    }
}
