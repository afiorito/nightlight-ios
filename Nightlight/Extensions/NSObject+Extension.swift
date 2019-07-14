import Foundation

extension NSObject {
    public class var className: String {
        return "\(type(of: self))"
    }
}
