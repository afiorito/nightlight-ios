/// Methods for handling UI actions occurring in a message detail view controller.
public protocol MessageDetailViewControllerDelegate: class {
    /**
    Tells the delegate when a message is updated.
    
    - parameter messageDetailViewController: a message detail view controller object informing about the message update.
    - parameter message: the message being updated.
    */
    func messageDetailViewController(_ messageDetailViewController: MessageDetailViewController, didUpdate message: MessageViewModel)
    
    /**
    Tells the delegate when a message is deleted.
    
    - parameter messageDetailViewController: a message detail view controller object informing about the message deletion.
    - parameter message: the message being deleted.
    */
    func messageDetailViewController(_ messageDetailViewController: MessageDetailViewController, didDelete message: MessageViewModel)
    
    /**
    Tells the delegate when a message is selected.
    
    - parameter messageDetailViewController: a message detail view controller object informing about the message selection action.
    - parameter message: the message needing more context.
    */
    func messageDetailViewController(_ messageDetailViewController: MessageDetailViewController, moreContextFor message: MessageViewModel)
    
    /**
    Tells the delegate when a message is appreciated.
    
    - parameter messageDetailViewController: a message detail view controller object informing about the message appreciation action.
    - parameter message: the message being appreciated.
    */
    func messageDetailViewController(_ messageDetailViewController: MessageDetailViewController, didAppreciate message: MessageViewModel)
    
    /**
    Tells the delegate when appreciation purchase is completed.
    
    - parameter messageDetailViewController: a message detail view controller object informing about the completion of appreciation purchasing.
    - parameter completed: a boolean for representing if the purchase is completed successfully.
    */
    func messageDetailViewControllerAppreciation(_ messageDetailViewController: MessageDetailViewController, didComplete complete: Bool)
}
