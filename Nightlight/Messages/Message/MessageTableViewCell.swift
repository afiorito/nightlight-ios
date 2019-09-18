import UIKit

/// A table view cell for displaying a message.
public class MessageTableViewCell: UITableViewCell {    
    /// The view model for handling state.
    private var viewModel: MessageViewModel?
    
    /// The content of the table view cell.
    private let messageContentView = MessageContentView()
    
    public var loveAction: (() -> Void)?
    public var appreciateAction: (() -> Void)?
    public var saveAction: (() -> Void)?
    public var contextAction: (() -> Void)?
    
    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
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
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        
        loveAction = nil
        appreciateAction = nil
        saveAction = nil
        contextAction = nil
    }
    
    public override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)

        UIView.animate(withDuration: 0.25) {
            if highlighted {
                switch self.theme {
                case .dark:
                    self.backgroundColor = UIColor.background(for: self.theme).lighter(amount: 0.05)
                case .light:
                    self.backgroundColor = UIColor.background(for: self.theme).darker(amount: 0.05)
                case .system: break
                }
            } else {
                self.backgroundColor = UIColor.background(for: self.theme)
            }
        }
    }
    
    /**
     Configure the cell with a viewModel.
     
     - parameter viewModel: The view model to configure the cell.
     */
    public func configure(with viewModel: MessageViewModel) {
        self.viewModel = viewModel

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
            messageContentView.leadingAnchor.constraint(equalTo: contentView.readableContentGuide.leadingAnchor),
            messageContentView.trailingAnchor.constraint(equalTo: contentView.readableContentGuide.trailingAnchor),
            messageContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15)
        ])
    }
    
    // MARK: - Gesture Recognizer  Handlers
    
    @objc private func loveTapped() {
        loveAction?()
    }
    
    @objc private func appreciateTapped() {
        appreciateAction?()
    }
    
    @objc private func saveTapped() {
        saveAction?()
    }
    
    @objc private func contextTapped() {
        contextAction?()
    }

}

// MARK: - Themeable

extension MessageTableViewCell: Themeable {
    public func updateColors(for theme: Theme) {
        if theme == .system {
            selectionStyle = .default
        } else {
            selectionStyle = .none
        }
        
        backgroundColor = .background(for: theme)
        messageContentView.updateColors(for: theme)
    }
}
