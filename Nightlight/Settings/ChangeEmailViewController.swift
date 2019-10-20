import UIKit

/// A view controller for changing a user's email.
public class ChangeEmailViewController: UIViewController {
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
        
        emailField.input.delegate = self
        emailField.input.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        confirmButton.addTarget(self, action: #selector(confirm), for: .touchUpInside)
        
        prepareSubviews()
        updateColors(for: theme)
    }
    
    private let headerView: HeaderBarView = {
        let headerView = HeaderBarView()
        headerView.titleLabel.text = Strings.setting.changeEmail
        return headerView
    }()
    
    /// A field for entering an email.
    private let emailField: FormTextField = {
        let textField = FormTextField()
        textField.input.icon = UIImage.icon.mail
        textField.input.placeholder = Strings.placeholder.email
        textField.input.keyboardType = .emailAddress
        textField.input.autocapitalizationType = .none
        textField.input.autocorrectionType = .no
        textField.input.textContentType = .emailAddress
        return textField
    }()
    
    /// The button to confirm the new email.
    private let confirmButton: ContainedButton = {
        let button = ContainedButton()
        button.backgroundColor = .brand
        button.isEnabled = false
        button.setTitle(Strings.setting.confirmNewEmail, for: .normal)
        return button
    }()
    
    private let container: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()

    private func prepareSubviews() {
        container.addArrangedSubviews([emailField, confirmButton])
        view.addSubviews([headerView, container])
        
        // Use a layout guide since the height of the container can
        // grow when there is an error.
        let centerGuide = UILayoutGuide()
        view.addLayoutGuide(centerGuide)
        
        NSLayoutConstraint.activate([
            centerGuide.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 72),
            centerGuide.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -72),
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            container.centerYAnchor.constraint(equalTo: centerGuide.centerYAnchor),
            container.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor)
        ])
    }
    
    @objc private func confirm() {
        viewModel.changeEmail(emailField.input.text ?? "")
    }
    
    /**
     Handle a text field change event.
     */
    @objc func textFieldDidChange() {
        confirmButton.isEnabled = !(emailField.input.text?.isEmpty ?? true)
    }
    
}

// MARK: - ChangeAccountDetail Event Delegate

extension ChangeEmailViewController: ChangeAccountDetailEventDelegate {
    public func didChange() {}
    
    public func didBeginChange() {
        confirmButton.isLoading = true
    }
    
    public func didEndChange() {
        confirmButton.isLoading = false
    }
    
    public func didFailChange(with error: PersonError) {
        if case let .emailExists(reasons) = error {
            if let emailReason = reasons.first(where: { $0.property == "email" }) {
                if emailReason.constraints[ValidationConstraint.userExists.rawValue] != nil {
                    emailField.error = Strings.auth.emailExists
                } else {
                    emailField.error = Strings.auth.invalidEmail
                }
            }
        }
    }
}

// MARK: - UITextField Delegate

extension ChangeEmailViewController: UITextFieldDelegate {
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

extension ChangeEmailViewController: Themeable {
    func updateColors(for theme: Theme) {
        view.backgroundColor = .background(for: theme)
        headerView.updateColors(for: theme)
        emailField.updateColors(for: theme)
    }
}

// MARK: - Custom Presentable

extension ChangeEmailViewController: CustomPresentable {
    public var frame: CustomPresentableFrame {
        let width: CustomPresentableSize.Dimension = UIDevice.current.userInterfaceIdiom == .pad ? .content(500) : .max
        return CustomPresentableFrame(x: .center, y: .center, width: width, height: .intrinsic)
    }
    
    public var insets: UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }

}
