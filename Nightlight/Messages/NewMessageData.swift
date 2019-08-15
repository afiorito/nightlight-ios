// An object representing data for creating a new message.
public struct NewMessageData: Codable {
    let title: String
    let body: String
    let numPeople: Int
    let isAnonymous: Bool
}
