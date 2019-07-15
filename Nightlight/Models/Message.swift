import Foundation

public struct Message: Codable {
    let id: Int
    let title: String
    let body: String
    let isAnonymous: Bool
    var isLoved: Bool
    let isAppreciated: Bool
    var isSaved: Bool
    var loveCount: Int
    let appreciationCount: Int
    let user: User
    let createdAt: Date
    let updatedAt: Date
}
