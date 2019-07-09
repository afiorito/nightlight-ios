import Foundation

public enum AuthError: Error {
    case validation([ErrorReason])
    case unknown
}
