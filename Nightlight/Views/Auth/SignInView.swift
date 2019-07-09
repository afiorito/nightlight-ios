import UIKit

public class SignInView: AuthView {    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
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
        headerText = "Welcome\nBack!"
        accountStatusLabel.text = "Don't have an account?"
        actionButton.setTitle("Sign up", for: .normal)
        authButton.setTitle("Sign In", for: .normal)
        
        fieldContainer.addArrangedSubviews([usernameField, passwordField])
    }
    
    public override func updateColors(for theme: Theme) {
        super.updateColors(for: theme)
        
        usernameField.updateColors(for: theme)
        passwordField.updateColors(for: theme)
    }
}
