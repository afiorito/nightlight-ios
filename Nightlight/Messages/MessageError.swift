import Foundation

/// An error that indicates problems with messages.
public enum MessageError: Error {
    /// The message title is invalid.
    case invalidTitle
    
    /// The message body is invalid.
    case invalidBody
    
    /// The number of people the message is sent to is invalid.
    case invalidNumPeople
    
    /// The user does not have sufficient tokens to appreciate a message.
    case insufficientTokens
    
    /// The message is already appreciated.
    case alreadyAppreciated
    
    /// The message action could not be performed.
    case failedAction(MessageActionType)
    
    /// The sent message could not be validated.
    case validation([ErrorReason])
    
    /// A retrieved message does not exist or is deleted.
    case notFound
    
    /// An unexpected error.
    case unknown
    
    var message: String {
        switch self {
        case .invalidTitle: return Strings.message.invalidTitle
        case .invalidBody: return Strings.message.invalidyBody
        case .invalidNumPeople: return Strings.message.invalidNumPeople
        case .insufficientTokens: return Strings.message.insufficientTokens
        case .alreadyAppreciated: return Strings.message.alreadyAppreciated
        case .failedAction: return Strings.error.couldNotConnect
        case .notFound: return Strings.message.notFound
        case .validation(let reasons):
            var message = Strings.error.unknown

            if let titleReason = reasons.first(where: { $0.property == "title" }) {
                if titleReason.constraints[ValidationConstraint.maxLength.rawValue] != nil {
                    message = Strings.message.titleTooLong
                } else if titleReason.constraints[ValidationConstraint.minLength.rawValue] != nil {
                    message = Strings.message.titleTooShort
                }
            }
            
            if let bodyReason = reasons.first(where: { $0.property == "body" }) {
                if bodyReason.constraints[ValidationConstraint.maxLength.rawValue] != nil {
                    message = Strings.message.bodyTooLong
                } else if bodyReason.constraints[ValidationConstraint.minLength.rawValue] != nil {
                    message = Strings.message.bodyTooShort
                }
            }
            
            return message
            
        case .unknown: return Strings.error.couldNotConnect
        }
    }
}
