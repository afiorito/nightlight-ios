import UIKit

public class BasicOptionTableViewCell: BaseStaticTableViewCell {
    
    public var title: String? {
        get { return textLabel?.text }
        set { textLabel?.text = newValue }
    }
    
    public override var isSelected: Bool {
        didSet {
            if isSelected {
                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
                imageView.image = UIImage(named: "check")
                imageView.tintColor = .success
                accessoryView = imageView
            } else {
                accessoryView = nil
            }
        }
    }
    
    private let disclosureIndicator = UIImageView(image: UIImage(named: "disclosure"))
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        updateColors(for: theme)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Themeable
    
    override func updateColors(for theme: Theme) {
            super.updateColors(for: theme)
            textLabel?.textColor = .primaryText(for: theme)
            backgroundColor = .background(for: theme)
        }
}
