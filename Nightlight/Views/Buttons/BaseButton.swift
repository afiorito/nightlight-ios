import UIKit

open class BaseButton: UIButton, Themeable {
    private var originalBackgroundColor: UIColor?
    
    private var originalTitleText: String?
    
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = UIColor.Palette.white
        return activityIndicator
    }()
    
    public var isLoading = false {
        didSet {
            if isLoading {
                originalTitleText = self.titleLabel?.text
                self.setTitle("", for: .normal)
                activityIndicator.startAnimating()
            } else {
                self.setTitle(originalTitleText, for: .normal)
                activityIndicator.stopAnimating()
            }
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.titleLabel?.font = UIFont.primary16ptBold
        
        prepareSubviews()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override var isHighlighted: Bool {
        willSet(willBeHighlighted) {
            if !isHighlighted && willBeHighlighted {
                originalBackgroundColor = backgroundColor
            }
        }
        didSet {
            backgroundColor = isHighlighted ? originalBackgroundColor?.darker(amount: 0.1) : originalBackgroundColor
        }
    }
    
    private func prepareSubviews() {
        addSubviews(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func updateColors(for theme: Theme) {}

}
