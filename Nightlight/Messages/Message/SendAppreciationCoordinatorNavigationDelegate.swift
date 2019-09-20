/// Methods for handling `SendAppreciationCoordinator` navigation events.
public protocol SendAppreciationCoordinatorNavigationDelegate: class {
    /**
     Tells the delegate to dismiss after successful appreciation.
     */
    func sendAppreciationCoordinatorDidAppreciate(message: Message)
    
    /**
     Tells the delegate to dismiss after an unsuccessful appreciation.
     */
    func sendAppreciationCoordinatorDidFailToAppreciate(message: Message, with error: MessageError)
}
