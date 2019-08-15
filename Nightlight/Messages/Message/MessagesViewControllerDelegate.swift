import Foundation

/// Methods for handling UI actions occurring in a messages view controller.
public protocol MessagesViewControllerDelegate: class {
    /**
     Tells the delegate when a message is selected.
     
     - parameter messagesViewController: a messages view controller object informing about the message selection action.
     - parameter indexPath: the index path of the message being selected.
     */
    func messagesViewController(_ messagesViewController: MessagesViewController, didSelect message: MessageViewModel, at indexPath: IndexPath)
    
    /**
     Tells the delegate that more context is needed for a message.
     
     - parameter messagesViewController: a messages view controller object informing about the message context action.
     - parameter indexPath: the index path of the message needing more context.
     */
    func messagesViewController(_ messagesViewController: MessagesViewController, moreContextFor message: MessageViewModel, at indexPath: IndexPath)
    
    /**
     Tells the delegate when a message is appreciated.
     
     - parameter messagesViewController: a messages view controller object informing about the message appreciation action.
     - parameter message: the message being appreciated.
     - parameter indexPath: the index path of the message being appreciated.
     */
    func messagesViewController(_ messagesViewController: MessagesViewController, didAppreciate message: MessageViewModel, at indexPath: IndexPath)
    
    /**
     Tells the delegate when appreciation purchase is completed.
     
     - parameter messagesViewController: a messages view controller object informing about the completion of appreciation purchasing.
     - parameter completed: a boolean for representing if the purchase is completed successfully.
     */
    func messagesViewControllerAppreciation(_ messagesViewController: MessagesViewController, didComplete completed: Bool)
}
