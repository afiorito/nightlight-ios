import Foundation

extension Data {
    /**
     Decode a codable object to JSON.
     */
    public func decodeJSON<T: Decodable>() throws -> T {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(.iso8601Full)
        return try decoder.decode(T.self, from: self)
    }
    
    /**
     Encode a encodable object to JSON.
     
     - parameter value: the codable object to encode.
     */
    public static func encodeJSON<T: Encodable>(value: T) throws -> Data {
        return try JSONEncoder().encode(value)
    }
}
