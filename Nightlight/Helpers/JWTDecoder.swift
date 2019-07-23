import Foundation

class JWTDecoder {
    enum DecodeErrors: Error {
        case badToken
        case unknown
    }
    
    public func decode(_ jwt: String) throws -> [String: Any] {
        return try base64ToJSON(jwt.components(separatedBy: ".")[1])
    }
    
    private func base64Decode(_ base64: String) throws -> Data {
        let padded = base64.padding(toLength: ((base64.count + 3) / 4) * 4, withPad: "=", startingAt: 0)
        
        guard let decoded = Data(base64Encoded: padded) else {
            throw DecodeErrors.badToken
        }
        
        return decoded
    }
    
    private func base64ToJSON(_ value: String) throws -> [String: Any] {
        let root = try base64Decode(value)
        let json = try JSONSerialization.jsonObject(with: root, options: [])
        
        guard let payload = json as? [String: Any] else {
            throw DecodeErrors.unknown
        }
        
        return payload
    }
}
