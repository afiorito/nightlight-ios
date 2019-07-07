import UIKit

public class SignUpView: AuthView {
    
    public let usernameField: FormTextField = {
        let textField = FormTextField()
        textField.input.icon = UIImage(named: "icon_person")
        textField.input.placeholder = "username"
        textField.input.autocapitalizationType = .none
        textField.input.autocorrectionType = .no
        
        return textField
    }()
    
    public let emailField: FormTextField = {
        let textField = FormTextField()
        textField.input.icon = UIImage(named: "icon_mail")
        textField.input.placeholder = "email"
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
    
    public let signUpButton: ContainedButton = {
        let button = ContainedButton()
        button.setTitle("Sign up", for: .normal)
        return button
    }()
    
    private let fieldContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 15
        
        return stackView
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
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
    
    internal override func prepareSubviews() {
        super.prepareSubviews()
        
        headerBackground.shapeType = .signUp
        headerText = "Get\nStarted"
        accountStatusLabel.text = "Already have an account?"
        actionButton.setTitle("Log in", for: .normal)
        
        fieldContainer.addArrangedSubviews([usernameField, emailField, passwordField])
        addSubviews([fieldContainer, signUpButton])
        
        NSLayoutConstraint.activate([
            fieldContainer.centerXAnchor.constraint(equalTo: centerXAnchor),
            fieldContainer.centerYAnchor.constraint(equalTo: centerYAnchor),
            fieldContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            fieldContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            signUpButton.topAnchor.constraint(equalTo: fieldContainer.bottomAnchor, constant: 30),
            signUpButton.widthAnchor.constraint(equalTo: fieldContainer.widthAnchor),
            signUpButton.centerXAnchor.constraint(equalTo: fieldContainer.centerXAnchor)
        ])
    }
    
    public override func updateColors(for theme: Theme) {
        super.updateColors(for: theme)
        
        usernameField.updateColors(for: theme)
        emailField.updateColors(for: theme)
        passwordField.updateColors(for: theme)
    }
}
