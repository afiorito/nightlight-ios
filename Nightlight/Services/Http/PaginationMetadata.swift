/// A representation of server generated pagination metadata.
public struct PaginationMetadata: Codable {
    let start: String?
    let end: String?
    let limit: Int
    let total: Int
}
