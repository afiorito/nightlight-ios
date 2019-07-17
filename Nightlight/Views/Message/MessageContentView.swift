import UIKit

public class MessageContentView: UIView {

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
    
    public let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .primary20ptMedium
        label.numberOfLines = 3
        return label
    }()
    
    public let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = .secondary16ptNormal
        label.setContentHuggingPriority(.defaultLow + 1, for: .horizontal)
        return label
    }()
    
    public let timeAgoLabel: UILabel = {
        let label = UILabel()
        label.font = .secondary16ptNormal
        return label
    }()
    
    public let bodyLabel: UILabel = {
        let label = UILabel()
        label.font = .secondary16ptNormal
        label.numberOfLines = 0
        return label
    }()
    
    public let loveAction: ActionView = {
        let action = ActionView()
        action.button.isSelected = true
        action.button.setImage(UIImage(named: "heart_unselected"), for: .normal)
        action.button.setImage(UIImage(named: "heart_selected"), for: .selected)
        return action
    }()
    
    public let appreciateAction: ActionView = {
        let action = ActionView()
        action.button.setImage(UIImage(named: "sun_unselected"), for: .normal)
        action.button.setImage(UIImage(named: "sun_selected"), for: .selected)
        action.selectOnTap = false
        return action
    }()
    
    public let saveAction: ActionView = {
        let action = ActionView()
        action.isCountHidden = true
        action.button.setImage(UIImage(named: "bookmark_unselected"), for: .normal)
        action.button.setImage(UIImage(named: "bookmark_selected"), for: .selected)
        action.button.isSelected = true
        return action
    }()
    
    public let contextButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "context_menu"), for: .normal)
        button.setContentHuggingPriority(.defaultLow + 1, for: .horizontal)
        button.setContentCompressionResistancePriority(.defaultHigh + 1, for: .horizontal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        prepareSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func prepareSubviews() {
        bottomButtonLeftContainer.addArrangedSubviews([loveAction, appreciateAction])
        bottomButtonRightContainer.addArrangedSubviews([saveAction])
        bottomContainer.addArrangedSubviews([bottomButtonLeftContainer, bottomButtonRightContainer])
        
        addSubviews([titleLabel, contextButton, usernameLabel, timeAgoLabel, bodyLabel, bottomContainer])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contextButton.leadingAnchor, constant: -10),
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
            contextButton.widthAnchor.constraint(equalTo: contextButton.heightAnchor),
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
