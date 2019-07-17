import UIKit

extension UITableView: EmptyViewable {
    public var emptyView: EmptyView? {
        return backgroundView as? EmptyView
    }
    
    public func showEmptyView(description: EmptyViewDescription) {
        backgroundView = EmptyView(description: description)
    }
    
    public func hideEmptyView() {
        backgroundView = nil
    }
}
