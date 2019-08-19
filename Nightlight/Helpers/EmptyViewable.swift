import UIKit

/// A protocol for views that disable empty content.
public protocol EmptyViewable {
    var emptyView: EmptyView? { get }
    
    func showEmptyView(description: EmptyViewDescription)
    
    func hideEmptyView()
}
