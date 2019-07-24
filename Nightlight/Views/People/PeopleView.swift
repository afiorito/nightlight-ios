import UIKit

public class PeopleView: UIView {
    public let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(PersonTableViewCell.self, forCellReuseIdentifier: PersonTableViewCell.className)
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        tableView.separatorInset = .zero
        tableView.separatorStyle = .none

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

extension PeopleView: Themeable {
    func updateColors(for theme: Theme) {
        tableView.backgroundColor = .darkBackground(for: theme)
        tableView.reloadData()
    }
}
