import UIKit

extension UITableView {
    /**
     Register a cell using its class name as a reuse identifier.
     */
    func register(_ cellType: UITableViewCell.Type) {
        register(cellType, forCellReuseIdentifier: cellType.className)
    }
    
    /// A boolean denoting if the table view is loading.
    var isLoading: Bool {
        set {
            if newValue {
                backgroundView = {
                    let activityIndicator = UIActivityIndicatorView()
                    if let theme = (self.superview as? Themeable)?.theme {
                        activityIndicator.color = .gray(for: theme)
                    }
                    activityIndicator.startAnimating()
                    return activityIndicator
                }()
            } else {
                backgroundView = nil
            }
        }
        
        get {
            return (backgroundView is UIActivityIndicatorView)
        }
    }
}
