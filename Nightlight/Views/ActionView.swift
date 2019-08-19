import UIKit

/// A view with an action button and count label.
public class ActionView: UIView {
    /// A boolean that determines if the count label is hidden.
    var isCountHidden = false {
        didSet { countLabel.isHidden = isCountHidden }
    }
    
    /// A boolean that determines if the action is in the selected state.
    var isSelected: Bool {
        get { return button.isSelected }
        set { button.isSelected = newValue }
    }
    
    /// The count displayed on the count label.
    var count: Int {
        get { return Int(countLabel.text ?? "0") ?? 0 }
        set { countLabel.text = newValue.abbreviated }
    }
    
    /// A boolean that determines if the button is selected immediately after tapping.
    public var selectOnTap = true {
        didSet {
            if selectOnTap {
                removeSelectOnTap()
                enableSelectOnTap()
            } else {
                removeSelectOnTap()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        button.addTarget(self, action: #selector(minimize), for: .touchDown)
        button.addTarget(self, action: #selector(toggleSelection), for: .touchUpInside)
        
        prepareSubviews()
    }
    
    /**
     Enable select on tap by adding gesture recognizers.
     */
    private func enableSelectOnTap() {
        button.addTarget(self, action: #selector(minimize), for: .touchDown)
        button.addTarget(self, action: #selector(toggleSelection), for: .touchUpInside)
    }
    
    /**
     Disable select on tap by disabling gesture recognizers.
     */
    private func removeSelectOnTap() {
        button.removeTarget(self, action: #selector(minimize), for: .touchDown)
        button.removeTarget(self, action: #selector(toggleSelection), for: .touchUpInside)
    }
    
    /**
     Animate the views size smaller.
     */
    @objc private func minimize() {
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseIn], animations: {
            self.button.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        })
    }
    
    @objc private func toggleSelection() {
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            usingSpringWithDamping: 0.25,
            initialSpringVelocity: 3,
            options: [.curveEaseOut, .beginFromCurrentState],
            animations: {
                self.button.transform = .identity
            }
        )
        
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        
        self.button.isSelected = !self.button.isSelected
        self.count += self.button.isSelected ? 1 : -1
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// A button for the action.
    let button = BaseButton()
    
    /// A label for displaying a count.
    let countLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        return label
    }()
    
    let container: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 2
        return stackView
    }()
    
    private func prepareSubviews() {
        container.addArrangedSubviews([button, countLabel])
        
        addSubviews(container)
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: topAnchor),
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor),
            button.widthAnchor.constraint(equalTo: button.heightAnchor)
        ])
    }

}

// MARK: - Themeable

extension ActionView: Themeable {
    public func updateColors(for theme: Theme) {
        button.tintColor = .neutral
    }
}
