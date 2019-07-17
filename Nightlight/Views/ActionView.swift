import UIKit

public class ActionView: UIView {
    let container: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 2
        return stackView
    }()

    let button = UIButton()
    
    let countLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        return label
    }()
    
    var isCountHidden = false {
        didSet { countLabel.isHidden = isCountHidden }
    }
    
    var isSelected: Bool {
        get { return button.isSelected }
        set { button.isSelected = newValue }
    }
    
    var count: Int {
        get { return Int(countLabel.text ?? "0") ?? 0 }
        set { countLabel.text = "\(newValue)" }
    }
    
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
    
    private func enableSelectOnTap() {
        button.addTarget(self, action: #selector(minimize), for: .touchDown)
        button.addTarget(self, action: #selector(toggleSelection), for: .touchUpInside)
    }
    
    private func removeSelectOnTap() {
        button.removeTarget(self, action: #selector(minimize), for: .touchDown)
        button.removeTarget(self, action: #selector(toggleSelection), for: .touchUpInside)
    }
    
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

extension ActionView: Themeable {
    public func updateColors(for theme: Theme) {
        button.tintColor = .neutral
    }
}
