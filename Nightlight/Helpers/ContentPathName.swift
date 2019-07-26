import Foundation

public enum ContentPathName: String {
    case privacy = "https://nightlight.electriapp.com/privacy"
    case terms = "https://nightlight.electriapp.com/terms"
    case feedback = "https://nightlight.electriapp.com/feedback"
    case about = "https://nightlight.electriapp.com/about"
    
    var url: URL {
        return URL(string: self.rawValue)!
    }
    
    var title: String {
        switch self {
        case .privacy:
            return "Privacy Policy"
        case .terms:
            return "Terms"
        case .feedback:
            return "Feedback"
        case .about:
            return "About"
        }
    }
}
