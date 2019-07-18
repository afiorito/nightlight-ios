import Foundation

public enum MessageError: Error {
    case invalidTitle
    case invalidBody
    case invalidNumPeople
    case validation([ErrorReason])
    case unknown
    
    var message: String {
        switch self {
        case .invalidTitle: return "Message title is invalid."
        case .invalidBody: return "Message body is invalid."
        case .invalidNumPeople: return "Number of people is invalid."
        case .validation(let reasons):
            var message = "An unknown error occured."

            if let titleReason = reasons.first(where: { $0.property == "title" }) {
                if titleReason.constraints[ValidationConstraint.maxLength.rawValue] != nil {
                    message = "Message title is too long."
                } else if titleReason.constraints[ValidationConstraint.minLength.rawValue] != nil {
                    message = "Message title is too short"
                }
            }
            
            if let bodyReason = reasons.first(where: { $0.property == "body" }) {
                if bodyReason.constraints[ValidationConstraint.maxLength.rawValue] != nil {
                    message = "Message body is too long"
                } else if bodyReason.constraints[ValidationConstraint.minLength.rawValue] != nil {
                    message = "Body message is too short"
                }
            }
            
            return message
            
        case .unknown: return "Could not connect to Nightlight."
        }
    }
}
