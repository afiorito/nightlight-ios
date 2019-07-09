public enum ValidationConstraint: String {
    case userExists
    case weakPassword
}

public struct ErrorReason: Codable {
    let property: String
    let constraints: [String: String]
}

public struct ValidationErrorDescription: Codable {
    let message: String
    let reason: [ErrorReason]
    
}
