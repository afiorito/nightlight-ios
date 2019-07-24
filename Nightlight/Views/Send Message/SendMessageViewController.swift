import UIKit

public class SendMessageViewController: UITableViewController {

    private enum Section: Int, CaseIterable {
        case editing = 0
        case properties = 1
    }
    
    private let viewModel: SendMessageViewModel
    
    public weak var delegate: SendMessageViewControllerDelegate?
    
    let titleCell = MessageTitleCell()
    let bodyCell = MessageBodyCell()
    
    let numberOfPeopleCell = NumPeopleCell()
    
    let anonymousCell: SwitchTableViewCell = {
        let cell = SwitchTableViewCell()
        cell.textLabel?.text = "Send Anonymously"
        
        return cell
    }()
    
    init(viewModel: SendMessageViewModel) {
        self.viewModel = viewModel
        
        super.init(style: .grouped)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        addDidChangeThemeObserver()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "nb_send"),
                                                            style: .plain, target: self,
                                                            action: #selector(sendTapped))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "nb_cancel"),
                                                           style: .plain,
                                                           target: self, action: #selector(cancelTapped))
        
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        removeDidChangeThemeObserver()
    }
    
    @objc private func cancelTapped() {
        delegate?.sendMessageViewControllerDidCancel(self)
    }
    
    @objc private func sendTapped() {
        viewModel.sendMessage(
            title: titleCell.textField.text,
            body: bodyCell.textView.text,
            numPeople: numberOfPeopleCell.textField.text,
            isAnonymous: anonymousCell.switchControl.isOn) { [weak self] result in
                guard let self = self else { return }

                switch result {
                case .success(let message):
                    self.delegate?.sendMessageViewController(self, didSend: message)
                case .failure(let error):
                    self.showToast(error.message, severity: .urgent)
                }
        }
    }

    override public var preferredStatusBarStyle: UIStatusBarStyle {
        switch theme {
        case .light:
            if #available(iOS 13.0, *) {
                return .darkContent
            } else {
                return .default
            }
        case .dark:
            return .lightContent
        }
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

// MARK: UITableView Delegate

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
        navigationController?.navigationBar.barTintColor = .alternateBackground(for: theme)
        view.backgroundColor = .background(for: theme)
        tableView.backgroundColor = .background(for: theme)
        tableView.separatorColor = .border(for: theme)
    }
}
