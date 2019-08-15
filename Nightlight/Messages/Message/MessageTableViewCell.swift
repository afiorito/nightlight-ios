import UIKit

/// A table view cell for displaying a message.
public class MessageTableViewCell: UITableViewCell, Configurable {
    public typealias Delegate = MessageTableViewCellDelegate
    public typealias ViewModel = MessageViewModel
    
    /// The delegate for managing UI actions.
    public weak var delegate: MessageTableViewCellDelegate?
    
    //// the content of the table view cell.
    private let messageContentView = MessageContentView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        /// limit the number of lines when displaying a message in a cell.
        messageContentView.bodyLabel.numberOfLines = 10
        
        messageContentView.loveAction.button.addTarget(self, action: #selector(loveTapped), for: .touchUpInside)
        messageContentView.appreciateAction.button.addTarget(self, action: #selector(appreciateTapped), for: .touchUpInside)
        messageContentView.saveAction.button.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        messageContentView.contextButton.addTarget(self, action: #selector(contextTapped), for: .touchUpInside)
        
        prepareSubviews()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with viewModel: MessageViewModel) {
        messageContentView.titleLabel.text = viewModel.title
        messageContentView.usernameLabel.text = viewModel.displayName
        messageContentView.timeAgoLabel.text = viewModel.timeAgo
        messageContentView.bodyLabel.text = viewModel.body
        messageContentView.loveAction.isSelected = viewModel.isLoved
        messageContentView.loveAction.count = viewModel.loveCount
        messageContentView.appreciateAction.isSelected = viewModel.isAppreciated
        messageContentView.appreciateAction.count = viewModel.appreciationCount
        messageContentView.saveAction.isSelected = viewModel.isSaved
        
        updateColors(for: theme)
        
    }
    
    private func prepareSubviews() {
        contentView.addSubviews(messageContentView)
        
        NSLayoutConstraint.activate([
            messageContentView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            messageContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            messageContentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            messageContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15)
        ])
    }
    
    // MARK: - Gesture Recognizer  Handlers
    
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

}

// MARK: - Themeable

extension MessageTableViewCell: Themeable {
    public func updateColors(for theme: Theme) {
        backgroundColor = .background(for: theme)
        
        let background = UIView()
        selectedBackgroundView = background
        switch theme {
        case .light:
            background.backgroundColor = UIColor.background(for: theme).darker(amount: 0.05)
        case .dark:
            background.backgroundColor = UIColor.background(for: theme).lighter(amount: 0.05)
        }
        
        messageContentView.updateColors(for: theme)
    }
}
