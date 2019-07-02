import UIKit

/// A button that has no background color, just text.
class TextButton: BaseButton, Themeable {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 4
        self.contentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        self.titleLabel?.font = UIFont.primary16ptBold
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateColors(for theme: Theme) {
        setTitleColor(.primaryTextColor(for: theme), for: .normal)
        setTitleColor(UIColor.primaryTextColor(for: theme).darker(), for: .highlighted)
    }

}
