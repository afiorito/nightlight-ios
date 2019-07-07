import UIKit

/// A protocol that describes coordinator behaviour.
public protocol Coordinator: class {
    
    /// The parent coordinator of the current coordinator
    var parent: Coordinator? { get set }
    
    /// An array of view controllers that are children of the current view controller.
    var children: [Coordinator] { get set }
    
    /// The entry point of a coordinator.
    func start()
    
    func childDidFinish(_ child: Coordinator)
}

extension Coordinator {
    
    /**
     Allows a child coordinator to notify a parent coordinator that it has completed
     
     - parameter child: The child coordinator signaling completion
     */
    public func childDidFinish(_ child: Coordinator) {
        children.removeAll { $0 === child }
    }
    
    /**
     Adds the specified coordinator as a child of the current coordinator.
     */
    public func addChild(_ child: Coordinator) {
        child.parent = self
        children.append(child)
    }
}
