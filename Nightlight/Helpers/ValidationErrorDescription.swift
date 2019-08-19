/// A constant for validation error constraints.
public enum ValidationConstraint: String {
    case userExists
    case weakPassword
    case minLength
    case maxLength
}

/// A representation for an error reason.
public struct ErrorReason: Codable {
    let property: String
    let constraints: [String: String]
}

/// A representation for a validation error description.
public struct ValidationErrorDescription: Codable {
    let message: String
    let reason: [ErrorReason]
    
}
