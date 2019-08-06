import UIKit

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
