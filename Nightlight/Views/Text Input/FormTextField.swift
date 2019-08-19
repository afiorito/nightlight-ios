import UIKit

/// A view with a text field and error label for form input.
public class FormTextField: UIView {
    /// A textfield for user input.
    public let input: TextField = {
        let textField = TextField()
        textField.layer.borderColor = UIColor.urgent.cgColor
        
        return textField
    }()
    
    /// A label for displaying an error.
    public let errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .urgent
        label.font = .primary12ptNormal
        label.isHidden = true
        label.alpha = 0.0
        label.setContentHuggingPriority(.required + 1, for: .vertical)
        
        return label
    }()

    private let container: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 2
        
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        prepareSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// The error message to display for the field.
    public var error: String? {
        get {
            return errorLabel.text
        }
        
        set {
            // need to set text before when animating in and vice versa for animating out
            if let error = newValue {
                errorLabel.text = error
                animateError(isHidden: false)
            } else {
                animateError(isHidden: true) { _ in
                   self.errorLabel.text = nil
                }
            }
        }
    }
    
    private func prepareSubviews() {
        // Need empty UIView so that the error label animates properly. No idea why this works.
        // Without empty UIView, the label animates in from the top
        container.addArrangedSubviews([UIView(), input, errorLabel])
        addSubviews(container)
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: topAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor),
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            input.heightAnchor.constraint(equalToConstant: 40)
        ])
        
    }
    
    /**
     Show/Hide the error on the field using animation.
     
     - parameter isHidden: a boolean to determine if the error is animated in or out.
     - parameter completion: a block object to be executed when the animation sequence ends.
     */
    private func animateError(isHidden: Bool, completion: ((Bool) -> Void)? = nil) {
        let finalValue: CGFloat = isHidden ? 0.0 : 1.0
        
        UIView.animateKeyframes(withDuration: 0.25, delay: 0.0, options: .beginFromCurrentState, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1.0 / 3.0) {
                self.errorLabel.isHidden = isHidden
            }
            
            UIView.addKeyframe(withRelativeStartTime: 1.0 / 3.0, relativeDuration: 2.0 / 3.0) {
                self.errorLabel.alpha = finalValue
                self.input.layer.borderWidth = finalValue
            }
        }, completion: completion)
    }
    
}

// MARK: - Themeable

extension FormTextField: Themeable {
    public func updateColors(for theme: Theme) {
        input.updateColors(for: theme)
    }
}
