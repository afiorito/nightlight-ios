import Foundation

/// An error that indicates problems with authentication.
public enum AuthError: Error {
    /// The authentication credentials could not be validated.
    case validation([ErrorReason])
    
    /// The authentication failed unexpectedly.
    case unknown
}
