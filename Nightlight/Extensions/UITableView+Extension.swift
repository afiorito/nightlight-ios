import UIKit

extension UITableView {
    /**
     Register a cell using its class name as a reuse identifier.
     */
    func register(_ cellType: UITableViewCell.Type) {
        register(cellType, forCellReuseIdentifier: cellType.className)
    }
}
