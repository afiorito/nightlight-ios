import Foundation

/// An error for authentication events.
public enum AuthError: Error {
    case validation([ErrorReason])
    case unknown
}
