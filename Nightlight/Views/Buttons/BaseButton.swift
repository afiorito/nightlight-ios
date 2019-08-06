import UIKit

open class BaseButton: UIButton {
    private var originalBackgroundColor: UIColor?
    private var originalTitleText: String?
    
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = UIColor.Palette.white
        return activityIndicator
    }()
    
    public var isLoading = false {
        willSet {
            if newValue {
                originalTitleText = self.titleLabel?.text
                self.setTitle("", for: .normal)
                activityIndicator.startAnimating()
            }
        }
        
        didSet {
            isEnabled = !isLoading
            if !isLoading {
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
    
    open override func setTitle(_ title: String?, for state: UIControl.State) {
        if isLoading {
            originalTitleText = title
        } else {
            super.setTitle(title, for: .normal)
        }
    }
    
    private func prepareSubviews() {
        addSubviews(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let widthDelta = max(0, 60.0 - self.bounds.size.width)
        let heightDelta = max(60.0 - self.bounds.size.height, 0)
        let largerBounds = self.bounds.insetBy(dx: -0.5 * widthDelta, dy: -0.5 * heightDelta)
        return largerBounds.contains(point)
    }
}
