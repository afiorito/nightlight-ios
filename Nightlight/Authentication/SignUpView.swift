import UIKit

/// A view with authentication elements for sign up.
public class SignUpView: AuthView {
    
    /// The current input for the email.
    public var email: String {
        return emailField.input.text ?? ""
    }
    
    public override var isAuthButtonEnabled: Bool {
        return super.isAuthButtonEnabled && !email.isEmpty
    }
    
    /// A closure for notifying when a policy is selected.
    public var policyAction: ((URL) -> Void)?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        if #available(iOS 12.0, *) {
            passwordField.input.textContentType = .newPassword
        }

        emailField.input.delegate = self
        emailField.input.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        // move to next field when return is tapped.
        usernameField.input.addTarget(emailField.input,
                                      action: #selector(emailField.input.becomeFirstResponder),
                                      for: UIControl.Event.primaryActionTriggered)
        emailField.input.addTarget(passwordField.input,
                                   action: #selector(passwordField.input.becomeFirstResponder),
                                   for: UIControl.Event.primaryActionTriggered)
        passwordField.input.addTarget(passwordField.input,
                                      action: #selector(passwordField.input.resignFirstResponder),
                                      for: UIControl.Event.primaryActionTriggered)
        
        policiesTextView.delegate = self
        prepareSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func showFieldErrors(reasons: [ErrorReason]) {
        super.showFieldErrors(reasons: reasons)
        
        if let emailReason = reasons.first(where: { $0.property == "email" }) {
            if emailReason.constraints[ValidationConstraint.userExists.rawValue] != nil {
                emailField.error = Strings.auth.emailExists
            } else {
                emailField.error = Strings.auth.invalidEmail
            }
        }
    }
    
    /// A field for entering an email.
    public let emailField: FormTextField = {
        let textField = FormTextField()
        textField.input.icon = UIImage.icon.mail
        textField.input.placeholder = Strings.placeholder.email
        textField.input.keyboardType = .emailAddress
        textField.input.autocapitalizationType = .none
        textField.input.autocorrectionType = .no
        textField.input.textContentType = .emailAddress
        return textField
    }()
    
    /// A text view for denoting the app policies.
    public let policiesTextView: UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.isSelectable = true
        textView.backgroundColor = .clear

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineSpacing = 2
        
        let attributedString = NSMutableAttributedString(string: Strings.agreeToTerms,
                                                         attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        attributedString.addAttribute(.link, value: ExternalPage.terms.rawValue, range: NSRange(location: 31, length: 12))
        attributedString.addAttribute(.link, value: ExternalPage.privacy.rawValue, range: NSRange(location: 48, length: 14))
        
        textView.linkTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.brand]
        textView.attributedText = attributedString
        
        return textView
    }()
    
    override func prepareSubviews() {
        super.prepareSubviews()
        
        headerBackground.shapeType = .signUp
        headerText = Strings.auth.signUpHeaderText
        accountStatusLabel.text = Strings.auth.ownsAccount
        actionButton.setTitle(Strings.auth.signInButtonText, for: .normal)
        authButton.setTitle(Strings.auth.signUpButtonText, for: .normal)
        
        fieldContainer.addArrangedSubviews([emailField, usernameField, passwordField])
        addSubviews(policiesTextView)
        
        NSLayoutConstraint.activate([
            policiesTextView.topAnchor.constraint(equalTo: authButton.bottomAnchor),
            policiesTextView.leadingAnchor.constraint(equalTo: authButton.leadingAnchor, constant: 15),
            policiesTextView.trailingAnchor.constraint(equalTo: authButton.trailingAnchor, constant: -15),
            policiesTextView.bottomAnchor.constraint(lessThanOrEqualTo: bottomContainer.topAnchor, constant: -10)
        ])
    }
    
    // MARK: - Themeable
    
    public override func updateColors(for theme: Theme) {
        super.updateColors(for: theme)
        
        usernameField.updateColors(for: theme)
        emailField.updateColors(for: theme)
        passwordField.updateColors(for: theme)
        policiesTextView.textColor = .primaryText(for: theme)
    }
}

extension SignUpView: UITextViewDelegate {
    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        policyAction?(URL)
        
        return false
    }
}
