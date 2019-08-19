import UIKit

extension UITableView: EmptyViewable {
    /// The empty view when there is no table view content.
    public var emptyView: EmptyView? {
        return backgroundView as? EmptyView
    }
    
    /**
     Show the empty view.
     
     - parameter description: the empty view description.
     */
    public func showEmptyView(description: EmptyViewDescription) {
        backgroundView = EmptyView(description: description)
    }
    
    /**
     Hide the empty view.
     */
    public func hideEmptyView() {
        backgroundView = nil
    }
}
