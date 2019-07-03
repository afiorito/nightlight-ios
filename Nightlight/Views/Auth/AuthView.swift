import UIKit

public class AuthView: UIView {

    internal let headerBackground = AuthViewBackground()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "logo")
        return imageView
    }()
    
    private let headerTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = .primary42ptBold
        
        return label
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
        bottomContainer.addArrangedSubviews([accountStatusLabel, actionButton])
        addSubviews([headerBackground, logoImageView, headerTitleLabel, bottomContainer])
        
        NSLayoutConstraint.activate([
            headerBackground.topAnchor.constraint(equalTo: topAnchor),
            headerBackground.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerBackground.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerBackground.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1.0 / 3.0),
            logoImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 30),
            logoImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            logoImageView.heightAnchor.constraint(equalToConstant: 20),
            logoImageView.widthAnchor.constraint(equalToConstant: (20 / logoImageView.image!.size.height) * logoImageView.image!.size.width),
            headerTitleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 30),
            headerTitleLabel.leftAnchor.constraint(equalTo: logoImageView.leftAnchor),
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
