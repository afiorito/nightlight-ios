import UIKit

/// A button that has a background color.
public class ContainedButton: BaseButton {
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 4
        self.contentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
    }
    
    public override var isEnabled: Bool {
        didSet {
            alpha = isEnabled ? 1.0 : 0.65
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
