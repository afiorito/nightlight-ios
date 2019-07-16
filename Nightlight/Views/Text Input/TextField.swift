import UIKit

public class TextField: UITextField {
    
    public var icon: UIImage? {
        set {
            let icon = UIImageView(frame: CGRect(x: 10, y: 13, width: 14, height: 14))
            icon.image = newValue
            
            let iconContainer = UIView(frame: CGRect(x: 0, y: 0, width: 34, height: 40))
            iconContainer.addSubview(icon)
            
            leftView = iconContainer
            leftViewMode = .always
        }
        
        get {
            return (leftView?.subviews.first as? UIImageView)?.image
        }
    }
    
    public override var placeholder: String? {
        didSet {
            guard let attributedPlaceholder = attributedPlaceholder,
                let placeholder = placeholder,
                let color = attributedPlaceholder.attribute(.foregroundColor, at: 0, effectiveRange: nil)
                else { return }
            
            self.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor: color])
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        font = .secondary16ptNormal
        layer.cornerRadius = 4
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Themeable

extension TextField: Themeable {
    public func updateColors(for theme: Theme) {
        backgroundColor = .elementBackground(for: theme)
        tintColor = .accent(for: theme)
        attributedPlaceholder = NSAttributedString(string: placeholder ?? "", attributes: [.foregroundColor: UIColor.accent(for: theme)])
        textColor = .primaryText(for: theme)
    }
}
