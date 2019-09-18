import Foundation

/// Methods for handling message navigation events.
public protocol MessageNavigationDelegate: class {
    /**
     Tells the delegate that the message got updated.
     */
    func didUpdate(message: Message)
    
    /**
     Tells the delegate that the message got deleted.
     */
    func didDelete(message: Message)
    
    /**
     Tells the delegate to show a context menu.
     
     - parameter message: The message to show the context menu for.
     - parameter actions: The actions to show in the context menu.
     */
    func showContextMenu(for message: Message, with actions: [MessageContextAction])
    
    /**
     Tells the delegate to show the appreciation sheet.
     
     - parameter message: The message to show the appreciation sheet for.
     */
    func showAppreciationSheet(for message: Message)
}
