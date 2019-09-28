import UIKit

/// A view for displaying an alert mesage.
public class ToastView: UIView {
    /// A constant for denoting the severity of the toast.
    public enum Severity {
        case urgent
        case neutral
        case success
    }

    /// The severity of the toast.
    public var severity: Severity = .neutral {
        didSet {
            updateStyle()
        }
    }
    
    /// A view for displaying the severity color on the left side.
    private let colorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 4.0
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        
        return view
    }()
    
    /// An image view for displaying the severity icon.
    private let iconImageView = UIImageView()

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = .secondary14ptNormal
        label.numberOfLines = 0
        label.setContentHuggingPriority(.defaultHigh + 1, for: .vertical)
        
        return label
    }()
    
    /// The message of the toast.
    public var message: String? {
        get {
            return messageLabel.text
        }
        
        set {
            messageLabel.text = newValue
        }
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 4.0
        prepareSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     Update the styling of the view with the current severity.
     */
    private func updateStyle() {
        switch severity {
        case .neutral:
            iconImageView.image = UIImage.icon.urgent
            colorView.backgroundColor = .gray(for: theme)
        case .success:
            iconImageView.image = UIImage.icon.check
            colorView.backgroundColor = .success
        case .urgent:
            iconImageView.image = UIImage.icon.urgent
            colorView.backgroundColor = .urgent
        }
    }
    
    private func prepareSubviews() {
        addSubviews([colorView, iconImageView, messageLabel])
        
        let colorViewAspectConstraint = colorView.widthAnchor.constraint(equalTo: colorView.heightAnchor)
        colorViewAspectConstraint.priority = .required - 1
        
        NSLayoutConstraint.activate([
            colorView.topAnchor.constraint(equalTo: messageLabel.topAnchor, constant: -10),
            colorView.bottomAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 10),
            colorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            colorView.widthAnchor.constraint(equalToConstant: 35),
            iconImageView.centerXAnchor.constraint(equalTo: colorView.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: colorView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalTo: colorView.widthAnchor, multiplier: 0.65),
            iconImageView.heightAnchor.constraint(equalTo: iconImageView.widthAnchor),
            messageLabel.leadingAnchor.constraint(equalTo: colorView.trailingAnchor, constant: 10),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            messageLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -10)
        ])
    }
}

// MARK: - Themeable

extension ToastView: Themeable {
    public func updateColors(for theme: Theme) {
        iconImageView.tintColor = .secondaryBackground(for: theme)
        backgroundColor = .tertiaryBackground(for: theme)
        messageLabel.textColor = .label(for: theme)
        addShadow(forTheme: theme)
    }
}
