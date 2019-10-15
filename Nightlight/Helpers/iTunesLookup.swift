/// A representation from the itunes search api.
public struct iTunesSearchBody: Codable {
    let resultCount: Int
    let results: [iTunesRecord]
}

/// A representation of a result from the itunes search api.
public struct iTunesRecord: Codable {
    let userRatingCountForCurrentVersion: Int?
}
