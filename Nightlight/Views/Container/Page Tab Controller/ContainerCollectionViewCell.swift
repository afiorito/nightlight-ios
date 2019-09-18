import UIKit

/// A collection view cell container for view controllers.
class ContainerCollectionViewCell: UICollectionViewCell {
    
    // shouldSelect was not enough in the collection view delegate.
    override var isSelected: Bool {
        get { return false }
        set { _ = newValue }
    }
    
    public var childView: UIView? {
        willSet {
            if let childView = newValue {
                self.contentView.addSubviews(childView)
                
                NSLayoutConstraint.activate([
                    childView.topAnchor.constraint(equalTo: contentView.topAnchor),
                    childView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                    childView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                    childView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
                ])
                
            } else {
                childView?.removeFromSuperview()
            }
        }
    }
}
