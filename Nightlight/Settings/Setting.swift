import UIKit

/// An object from representing an app setting.
public struct Setting {
    let cellType: UITableViewCell.Type
    
    var configureCell: ((UITableViewCell) -> Void)?
    
    var selectionAction: ((IndexPath) -> Void)?
}
