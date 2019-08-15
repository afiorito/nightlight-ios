/// Server response for loving a message.
public struct MessageLoveResponse: Codable {
    let isLoved: Bool
}

/// Server response for saving a message.
public struct MessageSaveResponse: Codable {
    let isSaved: Bool
}

/// Server response for deleting a message.
public struct MessageDeleteResponse: Codable {
    let isDeleted: Bool
}

/// Server Response for appreciating a message.
public struct MessageAppreciateResponse: Codable {
    let isAppreciated: Bool
}
