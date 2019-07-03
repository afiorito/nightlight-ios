import UIKit

/// A button that has no background color, just text.
public class TextButton: BaseButton {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func updateColors(for theme: Theme) {
        super.updateColors(for: theme)
        setTitleColor(.primaryText(for: theme), for: .normal)
        setTitleColor(UIColor.primaryText(for: theme).darker(), for: .highlighted)
    }

}
