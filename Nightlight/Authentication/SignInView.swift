import UIKit

/// A view with authentication elements for sign in.
public class SignInView: AuthView {    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        // move to next field when return is tapped.
        usernameField.input.addTarget(passwordField.input,
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
    
    internal override func prepareSubviews() {
        super.prepareSubviews()
        
        headerBackground.shapeType = .signIn
        headerText = Strings.auth.signInHeaderText
        accountStatusLabel.text = Strings.auth.noAccount
        actionButton.setTitle(Strings.auth.signUpButtonText, for: .normal)
        authButton.setTitle(Strings.auth.signInButtonText, for: .normal)
        
        fieldContainer.addArrangedSubviews([usernameField, passwordField])
    }
    
    public override func showFieldErrors(reasons: [ErrorReason]) {
        // don't display specific errors during sign in.
        usernameField.error = ""
        passwordField.error = ""
    }
    
    // MARK: - Themeable
    
    public override func updateColors(for theme: Theme) {
        super.updateColors(for: theme)
        
        usernameField.updateColors(for: theme)
        passwordField.updateColors(for: theme)
    }
}
