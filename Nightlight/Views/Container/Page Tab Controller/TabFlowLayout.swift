import UIKit

/// A collection view flow layout for tabs with separators.
public class TabFlowLayout: UICollectionViewFlowLayout {
    override public init() {
        super.init()
        register(TabSeparatorView.self, forDecorationViewOfKind: TabSeparatorView.className)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let layoutAttributes = super.layoutAttributesForElements(in: rect) ?? []
        
        var decorationAttributes: [UICollectionViewLayoutAttributes] = []
        
        for layoutAttribute in layoutAttributes where layoutAttribute.indexPath.item > 0 {
            let separatorAttribute = UICollectionViewLayoutAttributes(forDecorationViewOfKind: TabSeparatorView.className,
                                                                      with: layoutAttribute.indexPath)
            
            let cellFrame = layoutAttribute.frame
            let separatorSize = CGSize(width: self.minimumLineSpacing, height: cellFrame.height / 2)
            separatorAttribute.frame = CGRect(x: cellFrame.origin.x,
                                              y: separatorSize.height / 2,
                                              width: separatorSize.width,
                                              height: separatorSize.height)
            separatorAttribute.zIndex = Int.max
            decorationAttributes.append(separatorAttribute)
        }
        
        return layoutAttributes + decorationAttributes
    }
}
