import UIKit

/// A table view cell with a title label for an option.
public class BasicOptionTableViewCell: BaseStaticTableViewCell {
    
    /// The title of the option.
    public var title: String? {
        get { return textLabel?.text }
        set { textLabel?.text = newValue }
    }
    
    public var isCurrentOption: Bool = false {
        didSet {
            if isCurrentOption {
                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
                imageView.image = UIImage.icon.check
                imageView.tintColor = .success
                accessoryView = imageView
            } else {
                accessoryView = nil
            }
        }
    }
    
    /// An image view for displaying a disclosure indicator.
    private let disclosureIndicator = UIImageView(image: UIImage.glyph.disclosure)
    
    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        updateColors(for: theme)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Themeable
    
    public override func updateColors(for theme: Theme) {
            super.updateColors(for: theme)
            textLabel?.textColor = .label(for: theme)
            backgroundColor = .background(for: theme)
        }
}
