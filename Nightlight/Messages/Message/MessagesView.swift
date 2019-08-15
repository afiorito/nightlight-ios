import UIKit

/// A view for displaying a list of messages.
public class MessagesView: UIView {
    
    /// A table view for displaying a list of messages.
    public let tableView: UITableView = {
        let tableView = UITableView()
        tableView.tableFooterView = UIView()
        tableView.register(MessageTableViewCell.self, forCellReuseIdentifier: MessageTableViewCell.className)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 150
        tableView.separatorInset = .zero
        
        return tableView
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        prepareSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func prepareSubviews() {
        addSubviews(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

}

// MARK: - Themeable

extension MessagesView: Themeable {
    public func updateColors(for theme: Theme) {
        tableView.backgroundColor = .background(for: theme)
        tableView.separatorColor = .border(for: theme)
        (tableView.backgroundView as? Themeable)?.updateColors(for: theme)
        tableView.reloadData()
    }
}
