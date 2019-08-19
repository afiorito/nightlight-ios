import Foundation

/// An object for decoding a JWT string.
class JWTDecoder {
    /// An error for jwt decoding.
    enum DecodeErrors: Error {
        case badToken
        case unknown
    }
    
    /**
     Decode a jwt string.
     
     - parameter jwt: the jwt string to decode.
     */
    public func decode(_ jwt: String) throws -> [String: Any] {
        return try base64ToJSON(jwt.components(separatedBy: ".")[1])
    }
    
    /**
     Decode a base64 string.
     
     - parameter base64: a base64 string to decode.
     */
    private func base64Decode(_ base64: String) throws -> Data {
        let padded = base64.padding(toLength: ((base64.count + 3) / 4) * 4, withPad: "=", startingAt: 0)
        
        guard let decoded = Data(base64Encoded: padded) else {
            throw DecodeErrors.badToken
        }
        
        return decoded
    }
    
    /**
     Convert a base64 ecoded jwt string to JSON.
     
     - parameter value: the base64 encoded jwt string.
     */
    private func base64ToJSON(_ value: String) throws -> [String: Any] {
        let root = try base64Decode(value)
        let json = try JSONSerialization.jsonObject(with: root, options: [])
        
        guard let payload = json as? [String: Any] else {
            throw DecodeErrors.unknown
        }
        
        return payload
    }
}
