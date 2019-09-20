import UIKit

/// A protocol that describes coordinator behaviour.
public protocol Coordinator: class {
    
    /// The parent coordinator of the current coordinator.
    var parent: Coordinator? { get set }
    
    /// An array of view controllers that are children of the current view controller.
    var children: [Coordinator] { get set }
    
    /// The entry point of a coordinator.
    func start()
    
    /**
     Allows a child coordinator to notify a parent coordinator that it has completed.
     
     - parameter child: The child coordinator signaling completion.
     */
    func childDidFinish(_ child: Coordinator)
    
    /**
     Adds the specified coordinator as a child of the current coordinator.
     */
    func addChild(_ child: Coordinator)
    
    /**
     Remove the specified coordinator from the current coordinator.
     */
    func removeChild(_ child: Coordinator)
}

public extension Coordinator {
    func childDidFinish(_ child: Coordinator) {
        removeChild(child)
    }
    
    func removeChild(_ child: Coordinator) {
        children.removeAll { $0 === child }
    }
    
    func removeChild<T>(with type: T.Type) {
        children.removeAll { $0 is T }
    }
    
    func addChild(_ child: Coordinator) {
        child.parent = self
        children.append(child)
    }
}

public protocol TabBarCoordinator: Coordinator {
    var rootViewController: UINavigationController { get }
}
