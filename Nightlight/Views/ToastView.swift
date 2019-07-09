import UIKit

public class ToastView: UIView, Themeable {
    public enum Severity {
        case urgent
        case neutral
    }

    public var severity: Severity = .neutral {
        didSet {
            updateStyle()
        }
    }
    
    private let colorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 4.0
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        
        return view
    }()
    
    private let iconImageView = UIImageView()

    private let toastMessageLabel: UILabel = {
        let label = UILabel()
        label.font = .secondary14ptNormal
        
        return label
    }()
    
    public var message: String? {
        get {
            return toastMessageLabel.text
        }
        
        set {
            toastMessageLabel.text = newValue
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 4.0
        
        prepareSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateStyle() {
        switch severity {
        case .neutral:
            iconImageView.image = UIImage(named: "icon_urgent")
            colorView.backgroundColor = .neutral
        case .urgent:
            iconImageView.image = UIImage(named: "icon_urgent")
            colorView.backgroundColor = .urgent
        }
    }
    
    private func prepareSubviews() {
        addSubviews([colorView, iconImageView, toastMessageLabel])
        
        NSLayoutConstraint.activate([
            colorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            colorView.heightAnchor.constraint(equalTo: heightAnchor),
            colorView.widthAnchor.constraint(equalTo: colorView.heightAnchor),
            iconImageView.centerXAnchor.constraint(equalTo: colorView.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: colorView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalTo: colorView.widthAnchor, multiplier: 0.65),
            iconImageView.heightAnchor.constraint(equalTo: iconImageView.widthAnchor),
            toastMessageLabel.leadingAnchor.constraint(equalTo: colorView.trailingAnchor, constant: 10),
            toastMessageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            toastMessageLabel.centerYAnchor.constraint(equalTo: colorView.centerYAnchor)
        ])
    }
    
    public func updateColors(for theme: Theme) {
        switch severity {
        case .neutral:
            iconImageView.tintColor = .background(for: theme)
        case .urgent:
            iconImageView.tintColor = .background(for: theme)
        }
        
        addShadow(forTheme: theme)
        backgroundColor = .background(for: theme)
        toastMessageLabel.textColor = .primaryText(for: theme)
    }

}
