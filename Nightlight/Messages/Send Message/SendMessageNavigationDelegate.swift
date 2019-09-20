/// Methods for handling send message navigation events.
public protocol SendMessageNavigationDelegate: class {
    /**
     Tells the delegate the message got sent.
     
     - parameter message: The sent message.
     */
    func didSend(message: Message)
    
    /**
     Tells the delegate that the user is no longer sending a message.
     */
    func didFinishSendingMessage()
}
