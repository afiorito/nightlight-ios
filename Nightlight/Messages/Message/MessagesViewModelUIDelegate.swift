import Foundation

/// Methods for updating the user interface from a `MessagesViewModel`.
public protocol MessagesViewModelUIDelegate: class {
    /**
    Tells the delegate that fetching messages began.
    
    - parameter fromStart: A boolean denoting if the data is being fetched from the beginning of a paginated list.
    */
    func didBeginFetchingMessages(fromStart: Bool)
    
    /**
     Tells the delegate that fetching messages stopped.
     */
    func didEndFetchingMessages()
    
    /**
     Tells the delegate that fetching messages failed.
     
     - parameter error: The error for the fetching failure.
     */
    func didFailToFetchMessages(with error: MessageError)
    
    /**
     Tells the delegate that the messages fetched successfully.
     
     - parameter count: The count of the fetched messages.
     - parameter fromStart: A boolean denoting if the data is being fetched from the beginning of a paginated list.
     */
    func didFetchMessages(with count: Int, fromStart: Bool)
    
    /**
     Tells the delegate that a message got updated at the specified index path.
     
     - parameter indexPath: The index path of the updated message.
     */
    func didUpdateMessage(at indexPath: IndexPath)
    
    /**
     Tells the delegate that a message got deleted at the specified index path.
     
     - parameter indexPath: The index path of the deleted message.
     */
    func didDeleteMessage(at indexPath: IndexPath)
    
    /**
     Tells the delegate that the message failed to be deleted at the specified index path.
     
     - parameter error: The error for the deletion failure.
     - parameter indexPath: The index path of the message.
     */
    func didFailToDeleteMessage(with error: MessageError, at indexPath: IndexPath) 
    
    /**
     Tells the delegate that the message action failed at the specified index path.
     
     - parameter action: The action performed.
     - parameter error: The error for the action failure
     - parameter indexPath: The index path of the message.
     */
    func didFailToPerformMessage(action: MessageActionType, with error: MessageError, at indexPath: IndexPath)
    
    /**
     Tells the delegate that the message got reported at the specified index path.
     
     - parameter indexPath: The index path of the message.
     */
    func didReportMessage(at indexPath: IndexPath)
}
