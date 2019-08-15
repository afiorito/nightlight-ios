import Foundation

/// An error for message events.
public enum MessageError: Error {
    case invalidTitle
    case invalidBody
    case invalidNumPeople
    case insufficientTokens
    case alreadyAppreciated
    case validation([ErrorReason])
    case unknown
    
    var message: String {
        switch self {
        case .invalidTitle: return Strings.message.invalidTitle
        case .invalidBody: return Strings.message.invalidyBody
        case .invalidNumPeople: return Strings.message.invalidNumPeople
        case .insufficientTokens: return Strings.message.insufficientTokens
        case .alreadyAppreciated: return Strings.message.alreadyAppreciated
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
                    message = Strings.message.titleTooShort
                }
            }
            
            return message
            
        case .unknown: return Strings.error.couldNotConnect
        }
    }
}
