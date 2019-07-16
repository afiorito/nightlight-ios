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
    
    public var email: String {
        return emailField.input.text ?? ""
    }
    
    public override var isAuthButtonEnabled: Bool {
        return super.isAuthButtonEnabled && !email.isEmpty
    }
    
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
    }
    
    // MARK: - Themeable
    
    public override func updateColors(for theme: Theme) {
        super.updateColors(for: theme)
        
        usernameField.updateColors(for: theme)
        emailField.updateColors(for: theme)
        passwordField.updateColors(for: theme)
    }
}
