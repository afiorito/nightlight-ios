/// Methods for handling `MessageDetailCoordinator` navigation events.
public protocol MessageDetailCoordinatorNavigationDelegate: class {
    /**
     Tells the delegate that the message got updated.
     
     - parameter message: The updated message.
     */
    func messageDetailCoordinatorDidUpdate(message: Message)
    
    /**
     Tells the delegate that the message got deleted.
     
     - parameter message: The deleted message.
     */
    func messageDetailCoordinatorDidDelete(message: Message)
}
