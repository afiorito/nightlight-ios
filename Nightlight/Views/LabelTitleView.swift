import UIKit

public class LabelTitleView: UIView {

    public lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .primary24ptBold
        return label
    }()
    
    public var title: String? {
        get { return titleLabel.text }
        set { titleLabel.text = newValue }
    }
    
    override init(frame: CGRect) {
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

extension LabelTitleView: Themeable {
    func updateColors(for theme: Theme) {
        titleLabel.textColor = .primaryText(for: theme)
    }
}
