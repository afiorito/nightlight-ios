import UIKit

public class NotificationTableViewCell: UITableViewCell, Configurable {
    public typealias ViewModel = UserNotificationViewModel
    public typealias Delegate = AnyObject
    
    public weak var delegate: AnyObject?
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .secondary16ptNormal

        return label
    }()
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
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
            bodyLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            bodyLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            iconImageView.topAnchor.constraint(equalTo: bodyLabel.topAnchor, constant: -1),
            iconImageView.heightAnchor.constraint(equalToConstant: 22),
            iconImageView.widthAnchor.constraint(equalTo: iconImageView.heightAnchor)
        ])
    }
    
}

extension NotificationTableViewCell: Themeable {
    func updateColors(for theme: Theme) {
        contentView.backgroundColor = .background(for: theme)
        bodyLabel.textColor = .primaryText(for: theme)
    }
}
