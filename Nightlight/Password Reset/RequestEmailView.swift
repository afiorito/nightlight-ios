import UIKit

/// A view for requesting a reset email.
public class RequestEmailView: UIView {
    
    /// A callback for sending a reset email.
    public var sendResetEmailAction: ((String) -> Void)?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        emailField.input.delegate = self
        emailField.input.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        confirmButton.addTarget(self, action: #selector(sendResetEmail), for: .touchUpInside)
        
        prepareSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// A label for displaying title information.
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .primary16ptBold
        label.text = "Enter your account email"
        
        return label
    }()
    
    /// A label for displaying subtitle information.
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .secondary14ptNormal
        label.text = "You will receive a reset link at given email address."
        
        return label
    }()
    
    /// A field for entering a reset email email.
    public let emailField: FormTextField = {
        let textField = FormTextField()
        textField.input.icon = UIImage.icon.mail
        textField.input.placeholder = Strings.placeholder.resetEmail
        textField.input.keyboardType = .emailAddress
        textField.input.autocapitalizationType = .none
        textField.input.autocorrectionType = .no
        textField.input.textContentType = .emailAddress
        return textField
    }()
    
    /// The button to confirm the reset email.
    public let confirmButton: ContainedButton = {
        let button = ContainedButton()
        button.backgroundColor = .brand
        button.isEnabled = false
        button.setTitle(Strings.sendResetEmail, for: .normal)
        return button
    }()
    
    private let textContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 2
        return stackView
    }()
    
    private let container: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    private func prepareSubviews() {
        textContainer.addArrangedSubviews([titleLabel, subtitleLabel])
        container.addArrangedSubviews([textContainer, emailField, confirmButton])
        addSubviews(container)
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: topAnchor),
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    /**
     Handle a text field change event.
     */
    @objc func textFieldDidChange() {
        confirmButton.isEnabled = !(emailField.input.text?.isEmpty ?? true)
    }
    
    /**
     Handle a send reset email event.
     */
    @objc private func sendResetEmail() {
        sendResetEmailAction?(emailField.input.text ?? "")
    }
}

// MARK: - Themeable

extension RequestEmailView: Themeable {
    func updateColors(for theme: Theme) {
        titleLabel.textColor = .label(for: theme)
        subtitleLabel.textColor = .secondaryLabel(for: theme)
        emailField.updateColors(for: theme)
        
    }
}

// MARK: - UITextField Delegate

extension RequestEmailView: UITextFieldDelegate {
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let formTextField = textField.superview(ofType: FormTextField.self) else {
            return
        }
        
        if formTextField.error != nil {
            formTextField.error = nil
        }
    }
}
