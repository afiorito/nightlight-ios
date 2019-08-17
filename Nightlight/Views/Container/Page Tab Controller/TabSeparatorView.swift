import UIKit

/// A collection view reusable view for delimiting tabs with a separator line.
public class TabSeparatorView: UICollectionReusableView {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        updateColors(for: theme)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        self.frame = layoutAttributes.frame
        updateColors(for: theme)
    }
}

// MARK: - Themeable

extension TabSeparatorView: Themeable {
    func updateColors(for theme: Theme) {
        backgroundColor = .border(for: theme)
    }
}
