import UIKit

/// A table view cell with a title label and switch.
public class SwitchTableViewCell: BaseStaticTableViewCell {

    let switchControl = Switch()
    
    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        textLabel?.font = .primary17ptNormal
        accessoryView = switchControl
        
        updateColors(for: theme)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Themeable
    
    public override func updateColors(for theme: Theme) {
        super.updateColors(for: theme)
        textLabel?.textColor = .primaryText(for: theme)
        backgroundColor = .background(for: theme)
        accessoryView?.backgroundColor = .background(for: theme)
        switchControl.updateColors(for: theme)
    }
}
