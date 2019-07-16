import UIKit

public protocol EmptyViewable {
    var emptyView: EmptyView? { get }
    
    func showEmptyView(description: EmptyViewDescription)
    
    func hideEmptyView()
}
