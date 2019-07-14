import Foundation

extension Data {
    public func decodeJSON<T: Decodable>() throws -> T {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(.iso8601Full)
        return try decoder.decode(T.self, from: self)
    }
    
    public static func encodeJSON<T: Encodable>(value: T) throws -> Data {
        return try JSONEncoder().encode(value)
    }
}
