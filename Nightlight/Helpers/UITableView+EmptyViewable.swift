import UIKit

extension UITableView: EmptyViewable {
    /// The empty view when there is no table view content.
    public var emptyView: EmptyView? {
        return superview?.subview(ofType: EmptyView.self)
    }
    
    /**
     Show the empty view.
     
     - parameter description: the empty view description.
     */
    public func showEmptyView(description: EmptyViewDescription) {
        guard description.title != emptyView?.title else { return }

        emptyView?.removeFromSuperview()
        
        let emptyView = EmptyView(description: description)
        superview?.addSubviews(emptyView)
        
        NSLayoutConstraint.activate([
            emptyView.centerYAnchor.constraint(equalTo: centerYAnchor),
            emptyView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            emptyView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15)
        ])
    }
    
    /**
     Hide the empty view.
     */
    public func hideEmptyView() {
        emptyView?.removeFromSuperview()
    }
}
