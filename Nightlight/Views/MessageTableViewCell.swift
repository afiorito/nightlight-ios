import UIKit

public class MessageTableViewCell: UITableViewCell, Configurable, Themeable {
    public typealias Delegate = MessageTableViewCellDelegate
    public typealias ViewModel = MessageViewModel
    
    public weak var delegate: MessageTableViewCellDelegate?
    
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
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .primary20ptMedium
        label.numberOfLines = 3
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = .secondary16ptNormal
        label.setContentHuggingPriority(.defaultLow + 1, for: .horizontal)
        return label
    }()
    
    private let timeAgoLabel: UILabel = {
        let label = UILabel()
        label.font = .secondary16ptNormal
        return label
    }()

    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.font = .secondary16ptNormal
        label.numberOfLines = 0
        return label
    }()
    
    private let loveAction: ActionView = {
        let action = ActionView()
        action.button.isSelected = true
        action.button.setImage(UIImage(named: "heart_unselected"), for: .normal)
        action.button.setImage(UIImage(named: "heart_selected"), for: .selected)
        return action
    }()
    
    private let appreciateAction: ActionView = {
        let action = ActionView()
        action.button.setImage(UIImage(named: "sun_unselected"), for: .normal)
        action.button.setImage(UIImage(named: "sun_selected"), for: .selected)
        action.selectOnTap = false
        return action
    }()
    
    private let saveAction: ActionView = {
        let action = ActionView()
        action.isCountHidden = true
        action.button.setImage(UIImage(named: "bookmark_unselected"), for: .normal)
        action.button.setImage(UIImage(named: "bookmark_selected"), for: .selected)
        action.button.isSelected = true
        return action
    }()
    
    private let contextButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "context_menu"), for: .normal)
        button.setContentHuggingPriority(.defaultLow + 1, for: .horizontal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        loveAction.button.addTarget(self, action: #selector(loveTapped), for: .touchUpInside)
        appreciateAction.button.addTarget(self, action: #selector(appreciateTapped), for: .touchUpInside)
        saveAction.button.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        contextButton.addTarget(self, action: #selector(contextTapped), for: .touchUpInside)
        
        prepareSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with viewModel: MessageViewModel) {
        titleLabel.text = viewModel.title
        usernameLabel.text = viewModel.username
        timeAgoLabel.text = viewModel.timeAgo
        bodyLabel.text = viewModel.body
        loveAction.isSelected = viewModel.isLoved
        loveAction.count = viewModel.loveCount
        appreciateAction.isSelected = viewModel.isAppreciated
        appreciateAction.count = viewModel.appreciationCount
        saveAction.isSelected = viewModel.isSaved
        
        updateColors(for: viewModel.theme)
        
    }
    
    private func prepareSubviews() {
        bottomButtonLeftContainer.addArrangedSubviews([loveAction, appreciateAction])
        bottomButtonRightContainer.addArrangedSubviews([saveAction])
        bottomContainer.addArrangedSubviews([bottomButtonLeftContainer, bottomButtonRightContainer])
        contentView.addSubviews([titleLabel, contextButton, usernameLabel, timeAgoLabel, bodyLabel, bottomContainer])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contextButton.leadingAnchor, constant: -10),
            contextButton.topAnchor.constraint(equalTo: titleLabel.topAnchor),
            contextButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            usernameLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            usernameLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            timeAgoLabel.leadingAnchor.constraint(equalTo: usernameLabel.trailingAnchor),
            timeAgoLabel.topAnchor.constraint(equalTo: usernameLabel.topAnchor),
            timeAgoLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            bodyLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 10),
            bodyLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            bodyLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            bottomContainer.topAnchor.constraint(equalTo: bodyLabel.bottomAnchor, constant: 10),
            bottomContainer.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            bottomContainer.trailingAnchor.constraint(equalTo: contextButton.trailingAnchor),
            bottomContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            contextButton.heightAnchor.constraint(equalToConstant: 24),
            bottomContainer.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    @objc private func loveTapped() {
        delegate?.cellDidTapLove(self)
    }
    
    @objc private func appreciateTapped() {
        delegate?.cellDidTapAppreciate(self)
    }
    
    @objc private func saveTapped() {
        delegate?.cellDidTapSave(self)
    }
    
    @objc private func contextTapped() {
        delegate?.cellDidTapContext(self)
    }
    
    public func updateColors(for theme: Theme) {
        contentView.backgroundColor = .background(for: theme)
        titleLabel.textColor = .primaryText(for: theme)
        usernameLabel.textColor = .secondaryText
        timeAgoLabel.textColor = .secondaryText
        bodyLabel.textColor = .primaryText(for: theme)
        contextButton.tintColor = .neutral
        [loveAction, appreciateAction, saveAction].forEach { $0.updateColors(for: theme) }
    }

}
