import Foundation

public enum IAPIdentifier: String, CaseIterable {
    case tokens_100
    case tokens_300
    case tokens_500
    
    var fullIdentifier: String {
        return "com.electriapp.nightlight.\(self.rawValue)"
    }
}
