import UIKit

public class SelectOptionTableViewCell<E: RawRepresentable>: BaseStaticTableViewCell where E.RawValue == String {
    
    public var optionName: String? {
        get { return textLabel?.text }
        set { textLabel?.text = newValue }
    }
    
    public var optionValue: E? {
        didSet {
            detailTextLabel?.text = optionValue?.rawValue.capitalizingFirstLetter()
        }
    }
    
    private let disclosureIndicator = UIImageView(image: UIImage(named: "disclosure"))
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        
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
