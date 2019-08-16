/// A representation of a paginated server response.
public struct PaginatedResponse<Data: Codable>: Codable {
    let metadata: PaginationMetadata
    let data: [Data]
}
