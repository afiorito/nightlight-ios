import Foundation

public struct Message: Codable {
    let id: Int
    let title: String
    let body: String
    let isAnonymous: Bool
    let isLoved: Bool
    let isAppreciated: Bool
    let isSaved: Bool
    let loveCount: Int
    let appreciationCount: Int
    let user: User
    let createdAt: Date
    let updatedAt: Date
}
