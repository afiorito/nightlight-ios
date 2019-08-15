import UIKit

/// A view for display message content.
public class MessageContentView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        prepareSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// A label for the title of the message.
    public let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .primary20ptMedium
        label.numberOfLines = 3
        return label
    }()
    
    /// A label for the username of the message sender.
    public let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = .secondary16ptNormal
        label.setContentHuggingPriority(.defaultLow + 1, for: .horizontal)
        return label
    }()
    
    /// A label for the time the message is posted.
    public let timeAgoLabel: UILabel = {
        let label = UILabel()
        label.font = .secondary16ptNormal
        return label
    }()
    
    /// A label for the body of the message.
    public let bodyLabel: UILabel = {
        let label = UILabel()
        label.font = .secondary16ptNormal
        label.numberOfLines = 0
        return label
    }()
    
    /// A view for the love action of the message.
    public let loveAction: ActionView = {
        let action = ActionView()
        action.button.isSelected = true
        action.button.setImage(UIImage.icon.heartUnselected, for: .normal)
        action.button.setImage(UIImage.icon.heartSelected, for: .selected)
        return action
    }()
    
    /// A view for the appreciate action of the message.
    public let appreciateAction: ActionView = {
        let action = ActionView()
        action.button.setImage(UIImage.icon.sunUnselected, for: .normal)
        action.button.setImage(UIImage.icon.sunSelected, for: .selected)
        action.selectOnTap = false
        return action
    }()
    
    /// A view for the save action of the message.
    public let saveAction: ActionView = {
        let action = ActionView()
        action.isCountHidden = true
        action.button.setImage(UIImage.icon.bookmarkUnselected, for: .normal)
        action.button.setImage(UIImage.icon.bookmarkSelected, for: .selected)
        action.button.isSelected = true
        return action
    }()
    
    /// A view for the more context action of the message.
    public let contextButton: BaseButton = {
        let button = BaseButton()
        button.setImage(UIImage.icon.context, for: .normal)
        button.setContentHuggingPriority(.defaultLow + 1, for: .horizontal)
        button.setContentCompressionResistancePriority(.defaultHigh + 1, for: .horizontal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    // MARK: - Stack view containers
    
    private let bottomContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private let bottomButtonLeftContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 10
        return stackView
    }()
    
    private let bottomButtonRightContainer: UIStackView = {
        let stackView = UIStackView()
        return stackView
    }()
    
    private func prepareSubviews() {
        bottomButtonLeftContainer.addArrangedSubviews([loveAction, appreciateAction])
        bottomButtonRightContainer.addArrangedSubviews([saveAction])
        bottomContainer.addArrangedSubviews([bottomButtonLeftContainer, bottomButtonRightContainer])
        
        addSubviews([titleLabel, contextButton, usernameLabel, timeAgoLabel, bodyLabel, bottomContainer])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            contextButton.topAnchor.constraint(equalTo: titleLabel.topAnchor),
            contextButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            usernameLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            usernameLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            timeAgoLabel.leadingAnchor.constraint(equalTo: usernameLabel.trailingAnchor),
            timeAgoLabel.topAnchor.constraint(equalTo: usernameLabel.topAnchor),
            timeAgoLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            bodyLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 10),
            bodyLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            bodyLabel.trailingAnchor.constraint(equalTo: contextButton.trailingAnchor),
            bottomContainer.topAnchor.constraint(equalTo: bodyLabel.bottomAnchor, constant: 10),
            bottomContainer.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            bottomContainer.trailingAnchor.constraint(equalTo: contextButton.trailingAnchor),
            bottomContainer.bottomAnchor.constraint(equalTo: bottomAnchor),
            contextButton.heightAnchor.constraint(equalToConstant: 24),
            contextButton.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            bottomContainer.heightAnchor.constraint(equalToConstant: 24)
        ])
    }

}

// MARK: - Themeable

extension MessageContentView: Themeable {
    public func updateColors(for theme: Theme) {
        titleLabel.textColor = .primaryText(for: theme)
        usernameLabel.textColor = .secondaryText
        timeAgoLabel.textColor = .secondaryText
        bodyLabel.textColor = .primaryText(for: theme)
        contextButton.tintColor = .neutral
        [loveAction, appreciateAction, saveAction].forEach { $0.updateColors(for: theme) }
        loveAction.countLabel.textColor = .secondaryText
        appreciateAction.countLabel.textColor = .secondaryText
    }
}
