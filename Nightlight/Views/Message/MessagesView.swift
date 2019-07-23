import UIKit

public class MessagesView: UIView {
    public let tableView: UITableView = {
        let tableView = UITableView()
        tableView.tableFooterView = UIView()
        tableView.register(MessageTableViewCell.self, forCellReuseIdentifier: MessageTableViewCell.className)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300
        tableView.separatorInset = .zero
        tableView.contentInsetAdjustmentBehavior = .never
        
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

extension MessagesView: Themeable {
    public func updateColors(for theme: Theme) {
        tableView.backgroundColor = .background(for: theme)
        tableView.separatorColor = .border(for: theme)
        (tableView.backgroundView as? Themeable)?.updateColors(for: theme)
    }
}
