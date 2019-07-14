import UIKit

extension UITableView {
    public func showEmptyView(description: EmptyViewDescription) {
        let emptyView = EmptyView()
        emptyView.title = description.title
        emptyView.subtitle = description.subtitle
        emptyView.imageName = description.imageName
        
        backgroundView = emptyView
    }
    
    public func removeEmptyView() {
        backgroundView = nil
    }
    
    public func showEmptyViewIfNeeded(emptyViewDescription: EmptyViewDescription) {
        if self.visibleCells.isEmpty {
            showEmptyView(description: emptyViewDescription)
        } else {
            removeEmptyView()
        }
    }
}
