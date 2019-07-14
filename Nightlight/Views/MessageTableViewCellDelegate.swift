import UIKit

@objc public protocol MessageTableViewCellDelegate: class {
    func cellDidTapLove(_ cell: UITableViewCell)
    func cellDidTapAppreciate(_ cell: UITableViewCell)
    func cellDidTapSave(_ cell: UITableViewCell)
    func cellDidTapContext(_ cell: UITableViewCell)
}
