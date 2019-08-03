import UIKit

public class PersonContentView: UIView {

    private let container: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    private let textContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    private let accoladeContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = .primary16ptMedium
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .secondary14ptNormal
        
        return label
    }()
    
    let loveAccolade: AccoladeView = {
        let accoladeView = AccoladeView()
        accoladeView.actionView.isSelected = true
        accoladeView.actionView.button.setImage(UIImage(named: "heart_unselected"), for: .normal)
        accoladeView.actionView.button.setImage(UIImage(named: "heart_selected"), for: .selected)
        accoladeView.descriptionLabel.text = "Love"
        return accoladeView
    }()
    
    let appreciateAccolade: AccoladeView = {
        let accoladeView = AccoladeView()
        accoladeView.actionView.isSelected = true
        accoladeView.actionView.button.setImage(UIImage(named: "sun_unselected"), for: .normal)
        accoladeView.actionView.button.setImage(UIImage(named: "sun_selected"), for: .selected)
        accoladeView.descriptionLabel.text = "Appreciation"
        return accoladeView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        prepareSubviews()
        
        updateColors(for: theme)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func prepareSubviews() {
        container.addArrangedSubviews([textContainer, accoladeContainer])
        textContainer.addArrangedSubviews([usernameLabel, dateLabel])
        accoladeContainer.addArrangedSubviews([UIView(), loveAccolade, appreciateAccolade, UIView()])
        
        addSubviews(container)
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: topAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor),
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            loveAccolade.actionView.button.heightAnchor.constraint(equalToConstant: 22),
            appreciateAccolade.actionView.button.heightAnchor.constraint(equalToConstant: 22)
        ])
    }

}

extension PersonContentView: Themeable {
    func updateColors(for theme: Theme) {
        usernameLabel.textColor = .primaryText(for: theme)
        dateLabel.textColor = .secondaryText
        loveAccolade.updateColors(for: theme)
        appreciateAccolade.updateColors(for: theme)
    }
}