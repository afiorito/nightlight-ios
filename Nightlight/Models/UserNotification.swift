import Foundation

/// An object for representing a notification received by a user.
public struct AnyUserNotification: Codable {
    /// The notification type.
    let type: Int
    
    /// The id of the identity (message) the notification is associated with.
    let entityId: Int
    
    /// The payload of the notification.
    let data: Any?
    
    /// The date the notification was created.
    let createdAt: Date
    
    private enum CodingKeys: String, CodingKey {
        case type, entityId, createdAt
        case data
    }
    
    public init(from decoder: Decoder) throws {
        if Self.decoders.isEmpty || Self.encoders.isEmpty {
            Self.register(IncrementalNotificationData.self, for: NotificationType.loveMessage.rawValue)
            Self.register(IncrementalNotificationData.self, for: NotificationType.appreciateMessage.rawValue)
            Self.register(OneTimeNotificationData.self, for: NotificationType.receiveMessage.rawValue)
        }
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decode(Int.self, forKey: .type)
        entityId = try container.decode(Int.self, forKey: .entityId)
        createdAt = try container.decode(Date.self, forKey: .createdAt)
        
        if let decode = Self.decoders[type] {
            data = try decode(container)
        } else {
            data = .none
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(type, forKey: .type)
        try container.encode(entityId, forKey: .entityId)
        try container.encode(createdAt, forKey: .createdAt)
        
        if let data = self.data {
            guard let encode = Self.encoders[type] else {
                let context = EncodingError.Context(codingPath: [], debugDescription: "Invalid notification type: \(type)")
                throw EncodingError.invalidValue(self, context)
            }
            
            try encode(data, &container)
        } else {
            try container.encodeNil(forKey: .data)
        }
        
    }
    
    private typealias NotificationDecoder = (KeyedDecodingContainer<CodingKeys>) throws -> Any
    private typealias NotificationEncoder = (Any, inout KeyedEncodingContainer<CodingKeys>) throws -> Void
    
    private static var decoders: [Int: NotificationDecoder] = [:]
    private static var encoders: [Int: NotificationEncoder] = [:]
    
    static func register<N: Codable>(_ type: N.Type, for notificationType: Int) {
        decoders[notificationType] = { container in
            try container.decode(N.self, forKey: .data)
        }
        
        encoders[notificationType] = { data, container in
            try container.encode(data as! N, forKey: .data)
        }
    }
}

/// An object representing an incremental notification (eg. love)
public struct IncrementalNotificationData: Codable {
    let count: Int
    let title: String
    let username: String
}

/// An object representing a one time notification (eg. sending a message).
public struct OneTimeNotificationData: Codable {
    let username: String
}
