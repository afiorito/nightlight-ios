import Foundation

extension Data {
    public func decodeJSON<T: Codable>() -> T? {
        return try? JSONDecoder().decode(T.self, from: self)
    }
}
