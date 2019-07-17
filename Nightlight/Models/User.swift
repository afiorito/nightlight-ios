import Foundation

public struct User: Codable {
    let id: Int
    let username: String
    let totalLove: Int
    let totalAppreciation: Int
    let createdAt: Date
    let updatedAt: Date
}

public struct Sender: Codable {
    let id: Int
    let username: String
}
