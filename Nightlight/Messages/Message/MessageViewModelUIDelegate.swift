import Foundation

/// Methods for updating the user interface from a `MessageViewModel`.
public protocol MessageViewModelUIDelegate: class {
    /**
     Tells the delegate that the message got reported.
     */
    func didReportMessage()
    
    /**
     Tells the delegate that the message got updated.
     */
    func didUpdateMessage()
    
    /**
     Tells the delegate that the message failed to be deleted.
     
     - parameter error: The error for the deletion failure.
     */
    func didFailToDeleteMessage(with error: MessageError)
    
    /**
     Tells the delegate that the message action failed.
     
     - parameter action: The action performed.
     - parameter error: The error for the action failure.
     */
    func didFailToPerformMessage(action: MessageActionType, with error: MessageError)
}
