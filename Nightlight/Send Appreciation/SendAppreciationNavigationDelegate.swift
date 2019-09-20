/// Methods for handling send appreciation navigation events.
public protocol SendAppreciationNavigationDelegate: class {
    /**
     Tells the delegate the message got appreciated successfully.
     
     - parameter message: The appreciated message.
     */
    func didAppreciate(message: Message)
    
    /**
     Tells the delegate the message failed to appreciate.
     
     - parameter message: The message that failed to appreciate.
     - parameter error: The error for the appreciation failure.
     */
    func didFailToAppreciate(message: Message, with error: MessageError)
    
    /**
     Tells the delegate that the user is no longer appreciating the message.
     */
    func didFinishAppreciating()
    
    /**
     Tells the delegate to show the buy tokens modal.
     */
    func showBuyTokensModal()
}
