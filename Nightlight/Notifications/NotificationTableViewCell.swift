import UIKit

/// A table view cell for displaying a notification.
public class NotificationTableViewCell: UITableViewCell {    
    /// An image view for the notification icon.
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    /// A label for the notification body.
    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .secondary16ptNormal

        return label
    }()
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        prepareSubviews()
        updateColors(for: theme)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with viewModel: UserNotificationViewModel) {
        bodyLabel.attributedText = viewModel.body
        iconImageView.image = viewModel.icon
        
        updateColors(for: theme)
    }
    
    private func prepareSubviews() {
        contentView.addSubviews([iconImageView, bodyLabel])
        
        NSLayoutConstraint.activate([
            bodyLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            bodyLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 10),
            bodyLabel.trailingAnchor.constraint(equalTo: contentView.readableContentGuide.trailingAnchor),
            bodyLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            iconImageView.leadingAnchor.constraint(equalTo: contentView.readableContentGuide.leadingAnchor),
            iconImageView.topAnchor.constraint(equalTo: bodyLabel.topAnchor, constant: -1),
            iconImageView.heightAnchor.constraint(equalToConstant: 22),
            iconImageView.widthAnchor.constraint(equalTo: iconImageView.heightAnchor)
        ])
    }
    
}

// MARK: - Themeable

extension NotificationTableViewCell: Themeable {
    func updateColors(for theme: Theme) {
        selectedBackgroundView = {
            let view = UIView()
            view.backgroundColor = UIColor.gray3(for: theme).withAlphaComponent(0.3)
            return view
        }()
        
        backgroundColor = .background(for: theme)
        bodyLabel.textColor = .label(for: theme)
    }
}
