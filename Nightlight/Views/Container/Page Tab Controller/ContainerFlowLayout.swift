import UIKit

/// A flow layout for managing a collection view with cells acting as a container view controller.
public class ContainerFlowLayout: UICollectionViewFlowLayout {
    override public func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let collectionView = collectionView else { return false }

        if collectionView.bounds.width != newBounds.width {
            itemSize = newBounds.size
            return true
        }
        
        return false
    }
    
    public override func prepare() {
        super.prepare()
        
        if let collectionView = collectionView {
            itemSize = collectionView.bounds.size
        }
    }
}
