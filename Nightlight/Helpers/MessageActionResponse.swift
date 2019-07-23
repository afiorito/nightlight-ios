public struct MessageLoveResponse: Codable {
    let isLoved: Bool
}

public struct MessageSaveResponse: Codable {
    let isSaved: Bool
}

public struct MessageDeleteResponse: Codable {
    let isDeleted: Bool
}
