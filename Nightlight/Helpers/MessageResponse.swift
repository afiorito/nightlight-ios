public struct MessageResponse: Codable {
    let metadata: PaginationMetadata
    let data: [Message]
}
