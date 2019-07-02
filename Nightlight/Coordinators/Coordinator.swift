import UIKit

/// A protocol that describes coordinator behaviour.
public protocol Coordinator {
    
    /// An array of view controllers that are children of the current view controller.
    var children: [Coordinator] { get set }
    
    /// The entry point of a coordinator.
    func start()
}
