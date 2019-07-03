import UIKit

open class BaseButton: UIButton, Themeable {
    private var originalBackgroundColor: UIColor?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.titleLabel?.font = UIFont.primary16ptBold
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
    
    func updateColors(for theme: Theme) {}

}
