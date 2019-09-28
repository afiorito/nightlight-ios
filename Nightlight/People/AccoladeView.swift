import UIKit

/// A view for display an accolade and its total count.
public class AccoladeView: UIView {
    /// A view for displaying the type of accolade.
    let actionView: ActionView = {
        let actionView = ActionView()
        actionView.button.isUserInteractionEnabled = false
        return actionView
    }()
    
    /// A label for displaying the accolade description.
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .primary12ptNormal
        return label
    }()
    
    private let container: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        return stackView
    }()
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        prepareSubviews()
        updateColors(for: theme)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func prepareSubviews() {
        container.addArrangedSubviews([actionView, descriptionLabel])
        
        addSubviews(container)
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: topAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor),
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}

// MARK: - Themeable

extension AccoladeView: Themeable {
    func updateColors(for theme: Theme) {
        descriptionLabel.textColor = .secondaryLabel(for: theme)
        actionView.countLabel.textColor = .label(for: theme)
        actionView.updateColors(for: theme)
    }
}
