import Foundation

/// Methods for handling UI actions occurring on a message table view cell.
@objc public protocol MessageTableViewCellDelegate: class {
    /**
     Tells the delegate the cell did receive a love tap.
     
     - parameter cell: a message table view cell object informing about the love tap.
     */
    func cellDidTapLove(_ cell: MessageTableViewCell)
    
    /**
     Tells the delegate the cell did receive an appreciation tap.
     
     - parameter cell: a message table view cell object informing about the appreciation tap.
     */
    func cellDidTapAppreciate(_ cell: MessageTableViewCell)
    
    /**
     Tells the delegate the cell did receive a save tap.
     
     - parameter cell: a message table view cell object informing about the save tap.
     */
    func cellDidTapSave(_ cell: MessageTableViewCell)
    
    /**
     Tells the delegate the cell did receive a more context tap.
     
     - parameter cell: a message table view cell object informing about the more context tap.
     */
    func cellDidTapContext(_ cell: MessageTableViewCell)
}
