import UIKit

/// A view controller for changing a user's password.
public class ChangePasswordViewController: UIViewController {
    /// The viewModel for handling state.
    private let viewModel: AccountSettingsViewModel

    public init(viewModel: AccountSettingsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        headerView.cancelAction = { [weak self] in
            self?.dismiss(animated: true)
        }
        
        currentPasswordField.input.delegate = self
        newPasswordField.input.delegate = self
        currentPasswordField.input.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        newPasswordField.input.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        confirmButton.addTarget(self, action: #selector(confirm), for: .touchUpInside)
        
        prepareSubviews()
        updateColors(for: theme)
    }
    
    /// A view for displaying header information.
    private let headerView: HeaderBarView = {
        let headerView = HeaderBarView()
        headerView.titleLabel.text = Strings.setting.changePassword
        return headerView
    }()
    
    /// A field for entering the current password.
    private let currentPasswordField: FormTextField = {
        let textField = FormTextField()
        textField.input.icon = UIImage.icon.lock
        textField.input.placeholder = Strings.placeholder.currentPassword
        textField.input.isSecureTextEntry = true
        textField.input.autocapitalizationType = .none
        textField.input.autocorrectionType = .no
        textField.input.textContentType = .password
        return textField
    }()
    
    /// A field for entering the new password.
    private let newPasswordField: FormTextField = {
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
    
    /// The button to confirm the new email.
    private let confirmButton: ContainedButton = {
        let button = ContainedButton()
        button.backgroundColor = .brand
        button.isEnabled = false
        button.setTitle(Strings.setting.confirmNewPassword, for: .normal)
        return button
    }()
    
    private let container: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()

    private func prepareSubviews() {
        container.addArrangedSubviews([currentPasswordField, newPasswordField, confirmButton])
        view.addSubviews([headerView, container])
        
        // Use a layout guide since the height of the container can
        // grow when there is an error.
        let centerGuide = UILayoutGuide()
        view.addLayoutGuide(centerGuide)
        
        NSLayoutConstraint.activate([
            centerGuide.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 100),
            centerGuide.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100),
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            container.centerYAnchor.constraint(equalTo: centerGuide.centerYAnchor),
            container.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor)
        ])
    }
    
    @objc private func confirm() {
        viewModel.changePassword(currentPasswordField.input.text ?? "", newPassword: newPasswordField.input.text ?? "")
    }
    
    /**
     Handle a text field change event.
     */
    @objc func textFieldDidChange() {
        let isCurrentPasswordEmpty = currentPasswordField.input.text?.isEmpty ?? true
        let isNewPasswordEmpty = newPasswordField.input.text?.isEmpty ?? true
        confirmButton.isEnabled = !isCurrentPasswordEmpty && !isNewPasswordEmpty
    }
    
}

// MARK: - ChangeAccountDetail Event Delegate

extension ChangePasswordViewController: ChangeAccountDetailEventDelegate {
    public func didChange() {}
    
    public func didBeginChange() {
        confirmButton.isLoading = true
    }
    
    public func didEndChange() {
        confirmButton.isLoading = false
    }
    
    public func didFailChange(with error: PersonError) {
        if case let .validation(reasons) = error {
            if let passwordReason = reasons.first(where: { $0.property == "password" }) {
                if passwordReason.constraints[ValidationConstraint.weakPassword.rawValue] != nil {
                    newPasswordField.error = error.message
                } else {
                    currentPasswordField.error = error.message
                }
            }
        } else {
            showToast(Strings.error.couldNotConnect, severity: .urgent)
        }
    }
}

// MARK: - UITextField Delegate

extension ChangePasswordViewController: UITextFieldDelegate {
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let formTextField = textField.superview(ofType: FormTextField.self) else {
            return
        }
        
        if formTextField.error != nil {
            formTextField.error = nil
        }
    }
}

// MARK: - Themeable

extension ChangePasswordViewController: Themeable {
    func updateColors(for theme: Theme) {
        view.backgroundColor = .background(for: theme)
        headerView.updateColors(for: theme)
        currentPasswordField.updateColors(for: theme)
        newPasswordField.updateColors(for: theme)
    }
}

// MARK: - Custom Presentable

extension ChangePasswordViewController: CustomPresentable {
    public var frame: CustomPresentableFrame {
        let width: CustomPresentableSize.Dimension = UIDevice.current.userInterfaceIdiom == .pad ? .content(500) : .max
        return CustomPresentableFrame(x: .center, y: .center, width: width, height: .intrinsic)
    }
    
    public var insets: UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }

}
