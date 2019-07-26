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
    
    internal let bottomContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 5
        
        return stackView
    }()
    
    public let usernameField: FormTextField = {
        let textField = FormTextField()
        textField.input.icon = UIImage(named: "icon_person")
        textField.input.placeholder = "username"
        textField.input.autocapitalizationType = .none
        textField.input.autocorrectionType = .no
        
        return textField
    }()
    
    public let passwordField: FormTextField = {
        let textField = FormTextField()
        textField.input.icon = UIImage(named: "icon_lock")
        textField.input.placeholder = "password"
        textField.input.isSecureTextEntry = true
        textField.input.autocapitalizationType = .none
        textField.input.autocorrectionType = .no
        return textField
    }()
    
    internal let fieldContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 15
        
        return stackView
    }()
    
    public let authButton: ContainedButton = {
        let button = ContainedButton()
        button.isEnabled = false
        button.backgroundColor = .brand
        return button
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
    
    public var username: String {
        return usernameField.input.text ?? ""
    }
    
    public var password: String {
        return passwordField.input.text ?? ""
    }
    
    public var isAuthButtonEnabled: Bool {
        return !username.isEmpty && !password.isEmpty
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        usernameField.input.delegate = self
        passwordField.input.delegate = self
        usernameField.input.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        passwordField.input.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        prepareSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func showFieldErrors(reasons: [ErrorReason]) {
        if let usernameReason = reasons.first(where: { $0.property == "username" }) {
            if usernameReason.constraints[ValidationConstraint.userExists.rawValue] != nil {
                usernameField.error = "The username already exists."
            } else {
                usernameField.error = "The username is invalid."
            }
        }
        
        if let passwordReason = reasons.first(where: { $0.property == "password" }) {
            if passwordReason.constraints[ValidationConstraint.weakPassword.rawValue] != nil {
                passwordField.error = "The password is too weak."
            }
        }
    }
    
    internal func prepareSubviews() {
        headerContainer.addArrangedSubviews([logoImageView, headerTitleLabel])
        bottomContainer.addArrangedSubviews([accountStatusLabel, actionButton])
        addSubviews([headerBackground, headerContainer, fieldContainer, authButton, bottomContainer])
        
        NSLayoutConstraint.activate([
            headerBackground.topAnchor.constraint(equalTo: topAnchor),
            headerBackground.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerBackground.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerBackground.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1.0 / 3.0),
            headerContainer.topAnchor.constraint(lessThanOrEqualTo: safeAreaLayoutGuide.topAnchor, constant: 30),
            headerContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            headerContainer.bottomAnchor.constraint(equalTo: headerBackground.bottomAnchor, constant: -30),
            fieldContainer.topAnchor.constraint(equalTo: headerBackground.bottomAnchor, constant: 30),
            fieldContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            fieldContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            authButton.topAnchor.constraint(equalTo: fieldContainer.bottomAnchor, constant: 30),
            authButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            authButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            authButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            bottomContainer.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20),
            bottomContainer.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    @objc internal func textFieldDidChange() {
        authButton.isEnabled = isAuthButtonEnabled
    }
    
    // MARK: - Themeable
    
    public func updateColors(for theme: Theme) {
        backgroundColor = .background(for: theme)
        logoImageView.tintColor = .invertedPrimaryText(for: theme)
        headerTitleLabel.textColor = .invertedPrimaryText(for: theme)
        accountStatusLabel.textColor = .primaryText(for: theme)
        actionButton.updateColors(for: theme)
    }
}

// MARK: - UITextField Delegate

extension AuthView: UITextFieldDelegate {
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let formTextField = textField.superview(ofType: FormTextField.self) else {
            return
        }
        
        formTextField.error = nil
    }
}
