import UIKit

class ContainerCollectionViewCell: UICollectionViewCell {
    public var childView: UIView? {
        willSet {
            if let childView = newValue {
                self.contentView.addSubview(childView)
            } else {
                childView?.removeFromSuperview()
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        childView = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        childView?.frame = contentView.bounds
    }
}
