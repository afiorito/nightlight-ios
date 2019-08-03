import UIKit

extension UITableView {
    func register(_ cellType: UITableViewCell.Type) {
        register(cellType, forCellReuseIdentifier: cellType.className)
    }
}
