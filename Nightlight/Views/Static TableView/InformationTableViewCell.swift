import UIKit

/// A base table view cell with a title and subtitle.
public class InformationTableViewCell: BaseStaticTableViewCell {
    
    /// The information title.
    public var title: String? {
        get { return textLabel?.text }
        set { textLabel?.text = newValue }
    }
    
    /// The information subtitle.
    public var subtitle: String? {
        get { return detailTextLabel?.text }
        set { detailTextLabel?.text = newValue }
    }
    
    /// An image view for displaying a disclosure indicator.
    private let disclosureIndicator = UIImageView(image: UIImage.glyph.disclosure)
    
    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        accessoryView = disclosureIndicator
        
        updateColors(for: theme)
    }

    public var isLoading: Bool {
        get { return accessoryView is UIActivityIndicatorView }
        
        set {
            if newValue {
                let activityIndicator = UIActivityIndicatorView()
                activityIndicator.startAnimating()
                accessoryView = activityIndicator
                activityIndicator.sizeToFit()
            } else {
                accessoryView = disclosureIndicator
            }
        }
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
