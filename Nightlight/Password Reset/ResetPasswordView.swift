import UIKit

/// A view for requesting a password reset.
public class ResetPasswordView: UIView {
    
        /// A callback for resetting a password.
    public var resetPasswordAction: ((String) -> Void)?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        newPasswordField.input.delegate = self
        newPasswordField.input.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        confirmButton.addTarget(self, action: #selector(resetPassword), for: .touchUpInside)
        
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
        label.text = "Enter a new account password"
        
        return label
    }()
    
    /// A label for displaying subtitle information.
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .secondary14ptNormal
        label.text = "Choose a strong password that is memorable."
        
        return label
    }()
    
    /// A field for entering the new password.
    public let newPasswordField: FormTextField = {
        let textField = FormTextField()
        textField.input.icon = UIImage.icon.mail
        textField.input.icon = UIImage.icon.lock
        textField.input.placeholder = Strings.placeholder.newPassword
        textField.input.isSecureTextEntry = true
        textField.input.autocapitalizationType = .none
        textField.input.autocorrectionType = .no
        if #available(iOS 12.0, *) {
            textField.input.textContentType = .newPassword
        } else {
            textField.input.textContentType = .password
        }

        return textField
    }()
    
    /// The button to confirm the reset email.
    public let confirmButton: ContainedButton = {
        let button = ContainedButton()
        button.backgroundColor = .brand
        button.isEnabled = false
        button.setTitle(Strings.resetPassword, for: .normal)
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
        container.addArrangedSubviews([textContainer, newPasswordField, confirmButton])
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
        confirmButton.isEnabled = !(newPasswordField.input.text?.isEmpty ?? true)
    }
    
    /**
     Handle a reset password event.
     */
    @objc private func resetPassword() {
        resetPasswordAction?(newPasswordField.input.text ?? "")
    }
}

// MARK: - Themeable

extension ResetPasswordView: Themeable {
    func updateColors(for theme: Theme) {
        titleLabel.textColor = .label(for: theme)
        subtitleLabel.textColor = .secondaryLabel(for: theme)
        newPasswordField.updateColors(for: theme)
        
    }
}

// MARK: - UITextField Delegate

extension ResetPasswordView: UITextFieldDelegate {
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let formTextField = textField.superview(ofType: FormTextField.self) else {
            return
        }
        
        if formTextField.error != nil {
            formTextField.error = nil
        }
    }
}
