import Foundation

/// A constant for external web pages displaying in a web view.
public enum ExternalPage: String {
    case privacy = "https://nightlight.electriapp.com/privacy"
    case terms = "https://nightlight.electriapp.com/terms"
    case feedback = "https://nightlight.electriapp.com/feedback"
    case about = "https://nightlight.electriapp.com/about"
    
    var url: URL {
        return URL(string: self.rawValue)!
    }
    
    var title: String {
        switch self {
        case .privacy: return Strings.externalPage.privacyPolicy
        case .terms: return Strings.externalPage.termsOfUse
        case .feedback: return Strings.externalPage.feedback
        case .about: return Strings.externalPage.about
        }
    }
}
