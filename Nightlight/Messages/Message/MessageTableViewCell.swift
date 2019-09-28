import UIKit

/// A table view cell for displaying a message.
public class MessageTableViewCell: UITableViewCell {    
    /// The view model for handling state.
    private var viewModel: MessageViewModel?
    
    /// The content of the table view cell.
    public let messageContentView = MessageContentView()
    
    public var loveAction: ((UITableViewCell) -> Void)?
    public var appreciateAction: ((UITableViewCell) -> Void)?
    public var saveAction: ((UITableViewCell) -> Void)?
    public var contextAction: ((UITableViewCell) -> Void)?
    
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
        loveAction?(self)
    }
    
    @objc private func appreciateTapped() {
        appreciateAction?(self)
    }
    
    @objc private func saveTapped() {
        saveAction?(self)
    }
    
    @objc private func contextTapped() {
        contextAction?(self)
    }

}

// MARK: - Themeable

extension MessageTableViewCell: Themeable {
    public func updateColors(for theme: Theme) {
        selectedBackgroundView = {
            let view = UIView()
            view.backgroundColor = UIColor.gray3(for: theme).withAlphaComponent(0.3)
            return view
        }()
        
        backgroundColor = .background(for: theme)
        messageContentView.updateColors(for: theme)
    }
}
