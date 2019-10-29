/// Methods for handling user notification navigation events.
public protocol UserNotificationsNavigationDelegate: class {
    /**
     Tells the delegate to show the message detail with a specified id.
     
     - parameter id: The id of the message to show the detail for.
     */
    func showMessageDetail(with id: Int)
    
    /**
     Tells the delegate to show the love for a message with a specified id.
     
     - parameter id: The id of the message to show the love for.
     */
    func showMessageLove(for id: Int)
    
    /**
     Tells the delegate to show the appreciation for a message with a specified id.
     
     - parameter id: The id of the message to show the appreciation for.
     */
    func showMessageAppreciation(for id: Int)
}
