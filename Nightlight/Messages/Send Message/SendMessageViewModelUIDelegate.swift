/// Methods for updating the user interface from a `SendMessageViewModel`.
public protocol SendMessageViewModelUIDelegate: class {
    /**
     Tells the delegate that the message began sending.
     */
    func didBeginSending()
    
    /**
     Tells the delegate that the message stopped sending.
     */
    func didEndSending()
    
    /**
     Tells the delegate that the message failed to send.
     
     - parameter error: The error for the sending failure.
     */
    func didFailToSend(with error: MessageError)
}
