import Foundation

/// The object for representing a user.
public struct User: Codable {
    /// The unique id of the user.
    let id: Int
    
    /// The unique username of the user.
    let username: String
    
    /// The email of the user.
    let email: String?
    
    /// The number of tokens the user has.
    let tokens: Int
    
    /// The total love the user has accumulated.
    let totalLove: Int
    
    /// The total appreciation the user has accumulated.
    let totalAppreciation: Int
    
    /// The date the user was created.
    let createdAt: Date
    
    /// The last date when the message was updated.
    let updatedAt: Date
}

/// A user-like object with fewer properties.
public struct Sender: Codable {
    let id: Int
    let username: String
}
