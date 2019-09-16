import Foundation

/// A constant for the iap identifiers for app store connect.
public enum IAPIdentifier: String, CaseIterable {
    case token_100
    case token_300
    case token_500
    
    var fullIdentifier: String {
        return "com.electriapp.nightlight.\(self.rawValue)"
    }
}
