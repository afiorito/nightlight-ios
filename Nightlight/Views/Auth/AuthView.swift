import UIKit

public class AuthView: UIView {

    internal let headerBackground = AuthViewBackground()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .left
        imageView.image = UIImage(named: "logo_full")
        return imageView
    }()
    
    private let headerTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = .primary42ptBold
        
        return label
    }()
    
    private let headerContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    private let bottomContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 5
        
        return stackView
    }()
    
    internal let accountStatusLabel: UILabel = {
        let label = UILabel()
        label.font = .primary16ptNormal
        
        return label
    }()
    
    internal let actionButton = TextButton()
    
    internal var headerText: String? {
        get {
            return headerTitleLabel.attributedText?.string
        }
        
        set {
            let style = NSMutableParagraphStyle()
            style.lineSpacing = 0
            style.maximumLineHeight = 45
            
            let attrString = NSMutableAttributedString(string: newValue ?? "")
            attrString.addAttribute(.paragraphStyle, value: style, range: NSRange(location: 0, length: attrString.length))
            
            headerTitleLabel.attributedText = attrString
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        prepareSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func prepareSubviews() {
        headerContainer.addArrangedSubviews([logoImageView, headerTitleLabel])
        bottomContainer.addArrangedSubviews([accountStatusLabel, actionButton])
        addSubviews([headerBackground, headerContainer, bottomContainer])
        
        headerContainer.sizeToFit()
        
        NSLayoutConstraint.activate([
            headerBackground.topAnchor.constraint(equalTo: topAnchor),
            headerBackground.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerBackground.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerBackground.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1.0 / 3.0),
            headerContainer.topAnchor.constraint(lessThanOrEqualTo: safeAreaLayoutGuide.topAnchor, constant: 30),
            headerContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            headerContainer.bottomAnchor.constraint(equalTo: headerBackground.bottomAnchor, constant: -30),
            bottomContainer.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20),
            bottomContainer.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    public func updateColors(for theme: Theme) {
        backgroundColor = .background(for: theme)
        logoImageView.tintColor = .invertedPrimaryText(for: theme)
        headerTitleLabel.textColor = .invertedPrimaryText(for: theme)
        accountStatusLabel.textColor = .primaryText(for: theme)
        actionButton.updateColors(for: theme)
    }
}
