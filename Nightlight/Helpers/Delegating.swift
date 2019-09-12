/// A protocol for object that can delegate responsibilities to other objects.
public protocol Delegating: class {
    associatedtype Delegate: AnyObject

    /// The delegate for managing UI actions.
    var delegate: Delegate? { get set }
}
