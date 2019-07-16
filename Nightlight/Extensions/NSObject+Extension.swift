import Foundation

extension NSObject {
    public class var className: String {
        return String(describing: self.self)
    }
}
