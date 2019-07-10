import Foundation

extension Data {
    public func decodeJSON<T: Decodable>() -> T? {
        return try? JSONDecoder().decode(T.self, from: self)
    }
    
    public static func encodeJSON<T: Encodable>(value: T) -> Data? {
        return try? JSONEncoder().encode(value)
    }
}
