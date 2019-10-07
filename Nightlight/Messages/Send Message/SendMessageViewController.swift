import UIKit

/// A view controller for managing sending a message.
public class SendMessageViewController: UITableViewController {

    /// A constant for denoting the section of the table view.
    private enum Section: Int, CaseIterable {
        case editing = 0
        case properties = 1
    }
    
    /// The viewModel for handling state.
    private let viewModel: SendMessageViewModel
    
    /// The cell for displaying the title of a message.
    private let titleCell = MessageTitleCell()
    
    /// The cell for displaying the body of a message.
    private let bodyCell = MessageBodyCell()
    
    /// The cell for selecting the number of people.
    private let numberOfPeopleCell = NumPeopleCell()
    
    /// The cell for selecting if the message is sent anonymously.
    private let anonymousCell: SwitchTableViewCell = {
        let cell = SwitchTableViewCell()
        cell.textLabel?.text = Strings.message.sendAnonymously
        return cell
    }()
    
    public init(viewModel: SendMessageViewModel) {
        self.viewModel = viewModel
        
        super.init(style: .grouped)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        addDidChangeThemeObserver()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.icon.send, style: .plain, target: self, action: #selector(sendTapped))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.icon.cancel, style: .plain, target: self, action: #selector(cancelTapped))
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorInset = .zero
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude))
        bodyCell.textView.delegate = self
        
        anonymousCell.switchControl.isOn = viewModel.isAnonymous
        numberOfPeopleCell.textField.text = "3"
        
        updateColors(for: theme)
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if isBeingRemoved {
            viewModel.finish()
        }
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let centerX = anonymousCell.accessoryView?.center.x {
            numberOfPeopleCell.accessoryView?.center.x = centerX
        }
    }
    
    // MARK: - Gesture Recognizer Handlers.
    
    @objc private func cancelTapped() {
        viewModel.finish()
    }
    
    @objc private func sendTapped() {
        viewModel.sendMessage(title: titleCell.textField.text, body: bodyCell.textView.text, numPeople: numberOfPeopleCell.textField.text, isAnonymous: anonymousCell.switchControl.isOn)
    }
    
    deinit {
        removeDidChangeThemeObserver()
    }
}

// MARK: - SendMessageViewModel UI Delegate

extension SendMessageViewController: SendMessageViewModelUIDelegate {
    public func didFailToSend(with error: MessageError) {
        showToast(error.message, severity: .urgent)
    }
    
    public func didBeginSending() {
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    public func didEndSending() {
        navigationItem.rightBarButtonItem?.isEnabled = true
    }
}

// MARK: - UITableView DataSource

extension SendMessageViewController {
    public override func numberOfSections(in tableView: UITableView) -> Int {
        // one section for message editing, one section for message properties
        return Section.allCases.count
    }
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let messageSection = Section(rawValue: section)
            else { return 0 }
        
        switch messageSection {
        case .editing:
            return 2
        case .properties:
            return 2
        }
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let messageSection = Section(rawValue: indexPath.section)
            else { return UITableViewCell() }
        
        switch messageSection {
        case .editing:
            let cell = [titleCell, bodyCell][indexPath.row]
            
            return cell
        
        case .properties:
            let cell = [numberOfPeopleCell, anonymousCell][indexPath.row]
            
            return cell
        }
    }
    
}

// MARK: - UITableView Delegate

extension SendMessageViewController {
    public override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
}

// MARK: - UITextView Delegate

extension SendMessageViewController: UITextViewDelegate {
    public func textViewDidChange(_ textView: UITextView) {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}

// MARK: - Themeable

extension SendMessageViewController: Themeable {
    var theme: Theme {
        return viewModel.theme
    }

    public func updateColors(for theme: Theme) {
        if theme == .system {
            tableView.separatorColor = nil
        } else {
            tableView.separatorColor = .separator(for: theme)
        }

        navigationController?.setStyle(.secondary, for: theme)
        tableView.backgroundColor = .background(for: theme)
    }
}
