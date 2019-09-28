import UIKit

/// A table view cell for displaying a context menu option.
public class ContextOptionTableViewCell: UITableViewCell {
    /// A button for displaying the option.
    let optionButton: UIButton = {
        let button = UIButton()
        button.contentHorizontalAlignment = .left
        button.contentEdgeInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        button.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0.0, right: 0.0)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        prepareSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with contextOption: ContextOption) {
        optionButton.setTitle(contextOption.title, for: .normal)
        optionButton.setImage(contextOption.image, for: .normal)
        
        switch contextOption.style {
        case .destructive:
            optionButton.setTitleColor(.urgent, for: .normal)
            optionButton.tintColor = .urgent
        default:
            optionButton.setTitleColor(.label(for: theme), for: .normal)
            optionButton.tintColor = .label(for: theme)
        }
        
        updateColors(for: theme)
    }
    
    private func prepareSubviews() {
        contentView.addSubviews(optionButton)
        
        NSLayoutConstraint.activate([
            optionButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            optionButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            optionButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            optionButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}

// MARK: - Themeable

extension ContextOptionTableViewCell: Themeable {
    public func updateColors(for theme: Theme) {
        selectedBackgroundView = {
            let view = UIView()
            view.backgroundColor = UIColor.gray3(for: theme).withAlphaComponent(0.3)
            return view
        }()

        backgroundColor = .background(for: theme)
    }
}
