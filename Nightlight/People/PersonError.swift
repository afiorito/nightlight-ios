import Foundation

/// An error that indicates problems with people.
public enum PersonError: Error {
    /// User credentials could not be validated.
    case validation([ErrorReason])

    /// An unexpected error.
    case unknown
    
    var message: String {
        switch self {
        case .validation(let reasons):
            var message = Strings.error.unknown

            if let emailReason = reasons.first(where: { $0.property == "email" }) {
                if emailReason.constraints[ValidationConstraint.userExists.rawValue] != nil {
                    message = Strings.auth.emailExists
                } else {
                    message = Strings.auth.invalidEmail
                }
            }
            
            if let passwordReason = reasons.first(where: { $0.property == "password" }) {
                if passwordReason.constraints[ValidationConstraint.weakPassword.rawValue] != nil {
                    message = Strings.auth.weakPassword
                } else {
                    message = Strings.auth.incorrectPassword
                }
            }
            
            return message
        default:
            return Strings.error.couldNotConnect
        }
    }
}
