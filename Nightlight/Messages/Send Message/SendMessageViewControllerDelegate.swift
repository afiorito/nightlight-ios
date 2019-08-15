/// Methods for handling UI actions occurring in a sent message view controller.
public protocol SendMessageViewControllerDelegate: class {
    /**
     Tells the delegate when sending a message is cancelled.
     
     - parameter sendMessageViewController: a send message view controller object informing about the cancel action.
     */
    func sendMessageViewControllerDidCancel(_ sendMessageViewController: SendMessageViewController)
    
    /**
     Tells the delegate when a message is sent.
     
     - parameter sendMessageViewController: a send message view controller object informing about the message send action.
     - parameter message: the message being sent.
     */
    func sendMessageViewController(_ sendMessageViewController: SendMessageViewController, didSend message: MessageViewModel)
}
