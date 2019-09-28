import UIKit

/// A large title view.
public class LabelTitleView: UIView {
    /// A label for displaying the title.
    public lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .primary24ptBold
        return label
    }()
    
    /// The title of the view.
    public var title: String? {
        get { return titleLabel.text }
        set { titleLabel.text = newValue }
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        prepareSubviews()
        updateColors(for: theme)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.frame = frame
    }
    
    private func prepareSubviews() {
        addSubview(titleLabel)
    }
}

// MARK: - Themeable

extension LabelTitleView: Themeable {
    func updateColors(for theme: Theme) {
        titleLabel.textColor = .label(for: theme)
    }
}
