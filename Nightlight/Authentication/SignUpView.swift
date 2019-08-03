import UIKit

public class SignUpView: AuthView {
    
    public let emailField: FormTextField = {
        let textField = FormTextField()
        textField.input.icon = UIImage(named: "icon_mail")
        textField.input.placeholder = "email"
        textField.input.autocapitalizationType = .none
        textField.input.autocorrectionType = .no
        return textField
    }()
    
    public let policiesTextView: UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.isSelectable = true
        textView.backgroundColor = .clear

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineSpacing = 2
        
        let string = "By signing up you agree to the\nTerms of Use and Privacy Policy"
        let attributedString = NSMutableAttributedString(string: string, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        attributedString.addAttribute(.link, value: "https://nightlight.electriapp.com/terms", range: NSRange(location: 31, length: 12))
        attributedString.addAttribute(.link, value: ContentPathName.privacy.rawValue, range: NSRange(location: 48, length: 14))
        
        textView.linkTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.brand]
        textView.attributedText = attributedString
        
        return textView
    }()
    
    public var email: String {
        return emailField.input.text ?? ""
    }
    
    public override var isAuthButtonEnabled: Bool {
        return super.isAuthButtonEnabled && !email.isEmpty
    }
    
    public var policyAction: ((URL) -> Void)?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)

        emailField.input.delegate = self
        emailField.input.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
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
                emailField.error = "A user with that email already exists."
            } else {
                emailField.error = "The email is invalid."
            }
        }
    }
    
    internal override func prepareSubviews() {
        super.prepareSubviews()
        
        headerBackground.shapeType = .signUp
        headerText = "Get\nStarted"
        accountStatusLabel.text = "Already have an account?"
        actionButton.setTitle("Log in", for: .normal)
        authButton.setTitle("Sign Up", for: .normal)
        
        fieldContainer.addArrangedSubviews([usernameField, emailField, passwordField])
        
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
