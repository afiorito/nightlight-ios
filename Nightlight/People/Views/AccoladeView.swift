import UIKit

public class AccoladeView: UIView {
    private let container: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        return stackView
    }()
    
    let actionView: ActionView = {
        let actionView = ActionView()
        actionView.button.isUserInteractionEnabled = false
        return actionView
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .primary12ptNormal
        return label
    }()
    
    public override init(frame: CGRect) {
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
        descriptionLabel.textColor = .secondaryText
        actionView.countLabel.textColor = .primaryText(for: theme)
        actionView.updateColors(for: theme)
    }
}
