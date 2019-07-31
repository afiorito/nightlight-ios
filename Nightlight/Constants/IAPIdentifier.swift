import Foundation

public enum IAPIdentifier: String, CaseIterable {
    case appreciation
    
    var fullIdentifier: String {
        return "com.electriapp.nightlight.\(self.rawValue)"
    }
}
