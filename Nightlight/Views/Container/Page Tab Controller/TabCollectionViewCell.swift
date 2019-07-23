import UIKit

public class TabCollectionViewCell: UICollectionViewCell {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .primary16ptMedium
        return label
    }()
    
    public var title: String? {
        get { return titleLabel.text }
        set { titleLabel.text = newValue }
    }
    
    public override init(frame: CGRect) {
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
        backgroundColor = .background(for: theme)
        titleLabel.textColor = .secondaryText
    }
}
