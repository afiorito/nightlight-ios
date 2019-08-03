import Foundation

public enum HttpError: Error {
    case unauthorized
    case badRequest(Data)
    case notFound
    case internalError
    case unknown
    
    init(value: Int, reason: Data) {
        switch value {
        case 400: self = .badRequest(reason)
        case 401: self = .unauthorized
        case 404: self = .notFound
        case 500: self = .internalError
        default: self = .unknown
        }
    }
    
    var data: Data? {
        switch self {
        case .badRequest(let data):
            return data
        default: return .none
        }
    }
}
