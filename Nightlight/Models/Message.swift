import Foundation

/// An object for representing a message.
public struct Message: Codable {
    /// The unique id of a message
    let id: Int
    
    /// The title of the message.
    let title: String
    
    /// The body text of the message.
    let body: String
    
    /// A boolean denoting whether the message is sent anonymously.
    let isAnonymous: Bool
    
    /// A boolean for denoting if the message is loved.
    var isLoved: Bool
    
    /// A boolean for denoting if the message is appreciated.
    var isAppreciated: Bool
    
    /// A boolean for denoting if the message is saved.
    var isSaved: Bool
    
    /// The total love the message has received.
    var loveCount: Int
    
    /// The total appreciation the message has received.
    var appreciationCount: Int
    
    /// The sender of the message.
    let user: Sender
    
    /// The date the message was created.
    let createdAt: Date
    
    /// The last date when the message was updated.
    let updatedAt: Date
}
