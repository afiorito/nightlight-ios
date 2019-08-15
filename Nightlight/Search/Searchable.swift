import Foundation

// Methods for searchable objects.
@objc public protocol Searchable {
    func updateQuery(text: String)
}
