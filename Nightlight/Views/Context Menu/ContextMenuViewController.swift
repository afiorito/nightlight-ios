import UIKit

public class ContextMenuViewController: UIViewController {

    private var options = [ContextOption]()
    
    let tableView: CompactTableView = {
        let tableView = CompactTableView()
        tableView.register(ContextOptionTableViewCell.self, forCellReuseIdentifier: ContextOptionTableViewCell.className)
        tableView.separatorInset = .zero
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        
        return tableView
    }()
    
    let cancelButton: ContainedButton = {
        let button = ContainedButton()
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.font = .secondary16ptNormal
        button.setContentHuggingPriority(.defaultLow + 1, for: .vertical)
        button.setContentCompressionResistancePriority(.defaultHigh + 1, for: .vertical)
        button.addTarget(self, action: #selector(dismissMenu), for: .touchUpInside)
        return button
    }()
    
    override public func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        updateColors(for: theme)
        
        prepareSubviews()
    }
    
    public func addOption(_ option: ContextOption) {
        options.append(option)
    }
    
    @objc private func dismissMenu() {
        dismiss(animated: true)
    }
    
    private func prepareSubviews() {
        view.addSubviews([tableView, cancelButton])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            tableView.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cancelButton.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -10),
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            cancelButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ])
    }
}

// MARK: - UITableView DataSource

extension ContextMenuViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ContextOptionTableViewCell.className,
                                                 for: indexPath) as! ContextOptionTableViewCell
        
        cell.configure(with: options[indexPath.row])
        
        return cell
    }
    
}

// MARK: - UITableView Delegate

extension ContextMenuViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // without this, any code executed in this function is delayed.
        tableView.deselectRow(at: indexPath, animated: false)

        let option = options[indexPath.row]
        option.handler?(option)
    }
    
}

// MARK: - Themeable

extension ContextMenuViewController: Themeable {
    public func updateColors(for theme: Theme) {
        view.backgroundColor = .background(for: theme)
        tableView.backgroundColor = .background(for: theme)
        cancelButton.backgroundColor = .buttonNeutral(for: theme)
        cancelButton.setTitleColor(.primaryText(for: theme), for: .normal)
    }
}
