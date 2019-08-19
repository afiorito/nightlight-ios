import UIKit

/// A scroll view with equal intrinsic content size and content size.
public class CompactScrollView: UIScrollView {
    override public var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    override public var intrinsicContentSize: CGSize {
        return contentSize
    }

}

/// A table view with equal intrinsic content size and content size.
public class CompactTableView: UITableView {
    override public var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    override public var intrinsicContentSize: CGSize { 
        return contentSize
    }
}

/// A collection view with equal intrinsic content size and content size.
public class CompactCollectionView: UICollectionView {
    override public var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    override public var intrinsicContentSize: CGSize {
        return CGSize(width: contentSize.width, height: contentSize.height + contentInset.top + contentInset.bottom)
    }
}
