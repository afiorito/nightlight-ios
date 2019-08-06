import UIKit

/// A view with main authentication elements.
///
/// The view should be subclassed to provide a more specific auth view
/// such as sign in or sign up.
open class AuthView: UIView {

    /// A header background with organic shape.
    let headerBackground = AuthViewBackground()
    
    /// The nightlight logo image view.
    let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .left
        imageView.image = UIImage.fullLogo
        return imageView
    }()
    
    /// A header displaying the title of the auth view.
    let headerTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = .primary42ptBold
        
        return label
    }()
    
    /// A field for entering a username.
    let usernameField: FormTextField = {
        let textField = FormTextField()
        textField.input.icon = UIImage.icon.person
        textField.input.placeholder = Strings.placeholder.username
        textField.input.autocapitalizationType = .none
        textField.input.autocorrectionType = .no
        
        return textField
    }()
    
    /// A field for entering a password.
    let passwordField: FormTextField = {
        let textField = FormTextField()
        textField.input.icon = UIImage.icon.lock
        textField.input.placeholder = Strings.placeholder.password
        textField.input.isSecureTextEntry = true
        textField.input.autocapitalizationType = .none
        textField.input.autocorrectionType = .no
        return textField
    }()
    
    /// The button to select the auth method.
    let authButton: ContainedButton = {
        let button = ContainedButton()
        button.backgroundColor = .brand
        button.isEnabled = false
        return button
    }()
    
    /// A label for hinting whether a user has an account or not.
    let accountStatusLabel: UILabel = {
        let label = UILabel()
        label.font = .primary16ptNormal
        return label
    }()
    
    // The button to submit the auth action.
    let actionButton = TextButton()

    // MARK: - Stack Views
    
    let headerContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    let bottomContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 5
        
        return stackView
    }()

    let fieldContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 15
        return stackView
    }()
    
    // MARK: - AuthView State
    
    /// The text for the header title.
    var headerText: String? {
        get { return headerTitleLabel.attributedText?.string }
        
        set {
            let style = NSMutableParagraphStyle()
            style.lineSpacing = 0
            style.maximumLineHeight = 45
            
            let attrString = NSMutableAttributedString(string: newValue ?? "")
            attrString.addAttribute(.paragraphStyle, value: style, range: NSRange(location: 0, length: attrString.length))
            
            headerTitleLabel.attributedText = attrString
        }
    }
    
    /// The current input for the username.
    public var username: String {
        return usernameField.input.text ?? ""
    }
    
    /// The current input for the password.
    public var password: String {
        return passwordField.input.text ?? ""
    }
    
    /// A noolean value indicating whether the auth button is enabled.
    public var isAuthButtonEnabled: Bool {
        return !username.isEmpty && !password.isEmpty
    }
    
    // MARK: - Initialization
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        usernameField.input.delegate = self
        passwordField.input.delegate = self
        usernameField.input.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        passwordField.input.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        prepareSubviews()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     Display errors on authentication text fields.
     
     - parameter reasons: an array of errors to be displayed on the fields.
     */
    public func showFieldErrors(reasons: [ErrorReason]) {
        if let usernameReason = reasons.first(where: { $0.property == "username" }) {
            if usernameReason.constraints[ValidationConstraint.userExists.rawValue] != nil {
                usernameField.error = Strings.error.usernameExists
            } else {
                usernameField.error = Strings.error.invalidUsername
            }
        }
        
        if let passwordReason = reasons.first(where: { $0.property == "password" }) {
            if passwordReason.constraints[ValidationConstraint.weakPassword.rawValue] != nil {
                passwordField.error = Strings.error.weakPassword
            }
        }
    }
    
    func prepareSubviews() {
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
    
    /**
     Handle a text field change event.
     */
    @objc func textFieldDidChange() {
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
