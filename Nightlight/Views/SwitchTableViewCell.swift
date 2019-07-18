import UIKit

public class SwitchTableViewCell: UITableViewCell {

    let switchControl = Switch()
    
    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        textLabel?.font = .primary17ptNormal
        self.accessoryView = switchControl
        
        updateColors(for: theme)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Themeable

extension SwitchTableViewCell: Themeable {
    func updateColors(for theme: Theme) {
        textLabel?.textColor = .primaryText(for: theme)
        backgroundColor = .background(for: theme)
        accessoryView?.backgroundColor = .background(for: theme)
        switchControl.updateColors(for: theme)
    }
}
