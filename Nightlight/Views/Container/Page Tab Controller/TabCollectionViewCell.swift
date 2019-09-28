import UIKit

/// A collection view cell for displaying the content of a tab.
public class TabCollectionViewCell: UICollectionViewCell {
    /// The title of the tab.
    public var title: String? {
        get { return titleLabel.text }
        set { titleLabel.text = newValue }
    }

    /// A label for displaying the tab title.
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .primary16ptMedium
        return label
    }()
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        updateColors(for: theme)
        prepareSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func prepareSubviews() {
        contentView.addSubviews(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
}

// MARK: - Themeable

extension TabCollectionViewCell: Themeable {
    func updateColors(for theme: Theme) {
        backgroundColor = .clear
        titleLabel.textColor = .secondaryLabel(for: theme)
    }
}
