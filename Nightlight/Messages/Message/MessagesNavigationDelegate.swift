import Foundation

/// Methods for handling messages navigation events.
public protocol MessagesNavigationDelegate: class {
    /**
     Tells the delegate to show a context menu for a message at a specified index path.
     
     - parameter message: The message to show the context menu for.
     - parameter actions: The actions to show in the context menu.
     - parameter indexPath: The index path of the message.
     */
    func showContextMenu(for message: Message, with actions: [MessageContextAction], at indexPath: IndexPath)
    
    /**
     Tells the delegate to show the message detail for a specified index path.
     
     - parameter message: The message to show the detail for.
     - parameter indexPath: The index path of the message.
     */
    func showDetail(message: Message, at indexPath: IndexPath)
    
    /**
     Tells the delegate to show the appreciation sheet for a specified index path.
     
     - parameter message: The message to show the appreciation sheet for.
     - parameter indexPath: The index path of the message.
     */
    func showAppreciationSheet(for message: Message, at indexPath: IndexPath)
}
