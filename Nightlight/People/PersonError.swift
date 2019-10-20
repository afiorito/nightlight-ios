import Foundation

/// An error that indicates problems with people.
public enum PersonError: Error {
    /// Email tried to be changed to an existing email.
    case emailExists([ErrorReason])

    /// An unexpected error.
    case unknown
    
    var message: String {
        switch self {
        case .emailExists:
            return Strings.auth.emailExists
        default:
            return Strings.error.couldNotConnect
        }
    }
}
