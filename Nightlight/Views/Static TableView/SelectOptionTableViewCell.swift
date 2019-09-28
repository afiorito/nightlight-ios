import UIKit

/// A table view cell with a title and detail label for selecting from a list of options.
public class SelectOptionTableViewCell<E: RawRepresentable>: BaseStaticTableViewCell where E.RawValue == String {
    
    /// The name of the option.
    public var optionName: String? {
        get { return textLabel?.text }
        set { textLabel?.text = newValue }
    }
    
    /// The current value of the option.
    public var optionValue: E? {
        didSet {
            detailTextLabel?.text = optionValue?.rawValue.capitalizingFirstLetter()
        }
    }
    
    /// An image view for displaying a disclosure indicator.
    private let disclosureIndicator = UIImageView(image: UIImage.glyph.disclosure)
    
    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        
        accessoryView = disclosureIndicator
        
        updateColors(for: theme)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Themeable
    
    public override func updateColors(for theme: Theme) {
        super.updateColors(for: theme)
        detailTextLabel?.textColor = .secondaryLabel(for: theme)
        textLabel?.textColor = .label(for: theme)
        backgroundColor = .background(for: theme)
        disclosureIndicator.tintColor = .label(for: theme)
    }
}
