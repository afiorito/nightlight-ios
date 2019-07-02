import UIKit

open class BaseButton: UIButton {
    private var originalBackgroundColor: UIColor?
    
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

}
