/// An  object for representing a server error body.
public struct SimpleErrorBody: Codable {
    let message: String
    let reason: String
}
