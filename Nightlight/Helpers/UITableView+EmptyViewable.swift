import UIKit

extension UITableView: EmptyViewable {
    public var emptyView: EmptyView? {
        return backgroundView as? EmptyView
    }
    
    public func showEmptyView(description: EmptyViewDescription) {
        guard emptyView == nil else {
            return
        }
        
        let emptyView = EmptyView()
        emptyView.title = description.title
        emptyView.subtitle = description.subtitle
        emptyView.image = description.image
        
        backgroundView = emptyView
    }
    
    public func hideEmptyView() {
        backgroundView = nil
    }
}
