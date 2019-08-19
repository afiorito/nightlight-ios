import Foundation

extension NSObject {
    /// Returns the class name of an object as a string.
    public class var className: String {
        return String(describing: self.self)
    }
}
