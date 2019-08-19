import Foundation

extension NSRegularExpression {
    /**
     Returns a boolean for a string matching the regular expression.
     
     - parameter string: the string to match against the regular expression.
     */
    func matches(_ string: String) -> Bool {
        let range = NSRange(location: 0, length: string.utf16.count)
        return firstMatch(in: string, options: [], range: range) != nil
    }
}
