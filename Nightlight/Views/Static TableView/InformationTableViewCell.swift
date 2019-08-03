import UIKit

public class InformationTableViewCell: BaseStaticTableViewCell {
    
    public var title: String? {
        get { return textLabel?.text }
        set { textLabel?.text = newValue }
    }
    
    public var subtitle: String? {
        get { return detailTextLabel?.text }
        set { detailTextLabel?.text = newValue }
    }
    
    private let disclosureIndicator = UIImageView(image: UIImage(named: "disclosure"))
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        accessoryView = disclosureIndicator
        
        updateColors(for: theme)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Themeable
    
    override func updateColors(for theme: Theme) {
        super.updateColors(for: theme)
        detailTextLabel?.textColor = .secondaryText
        textLabel?.textColor = .primaryText(for: theme)
        backgroundColor = .background(for: theme)
        disclosureIndicator.tintColor = .primaryGrayScale(for: theme)
    }
}
