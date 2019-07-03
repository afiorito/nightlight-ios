import UIKit

public class SignInView: AuthView {
    
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
    
    public let signInButton: ContainedButton = {
        let button = ContainedButton()
        button.setTitle("Sign in", for: .normal)
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
        
        fieldContainer.addArrangedSubviews([usernameField, passwordField])
        addSubviews([fieldContainer, signInButton])
        
        NSLayoutConstraint.activate([
            fieldContainer.centerXAnchor.constraint(equalTo: centerXAnchor),
            fieldContainer.centerYAnchor.constraint(equalTo: centerYAnchor),
            fieldContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            fieldContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            signInButton.topAnchor.constraint(equalTo: fieldContainer.bottomAnchor, constant: 30),
            signInButton.widthAnchor.constraint(equalTo: fieldContainer.widthAnchor),
            signInButton.centerXAnchor.constraint(equalTo: fieldContainer.centerXAnchor)
        ])
    }
    
    public override func updateColors(for theme: Theme) {
        super.updateColors(for: theme)
        
        usernameField.updateColors(for: theme)
        passwordField.updateColors(for: theme)
    }
}
