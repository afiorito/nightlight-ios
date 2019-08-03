import UIKit

public class SendAppreciationViewController: UIViewController {

    private let viewModel: SendAppreciationViewModel
    
    public weak var delegate: SendAppreciationViewControllerDelegate?
    
    private var sendAppreciationView = SendAppreciationView()
    
    private var hasTokens: Bool {
        return viewModel.tokens > 0
    }
    
    init(viewModel: SendAppreciationViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()

        sendAppreciationView.cancelAction = { [weak self] in
            self?.dismiss(animated: true)
        }
        
        sendAppreciationView.actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        sendAppreciationView.numTokens = viewModel.tokens
        
        sendAppreciationView.actionButton.setTitle(hasTokens ? "Send Appreciation" : "Get Tokens", for: .normal)
        prepareSubviews()
        updateColors(for: theme)
    }
    
    private func prepareSubviews() {
        view.addSubviews(sendAppreciationView)
        
        NSLayoutConstraint.activate([
            sendAppreciationView.topAnchor.constraint(equalTo: view.topAnchor),
            sendAppreciationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sendAppreciationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sendAppreciationView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc public func cancel() {
        dismiss(animated: true)
    }
    
    @objc private func actionButtonTapped() {
        sendAppreciationView.actionButton.isEnabled = false
        sendAppreciationView.actionButton.isLoading = true
        delegate?.sendAppreciationViewControllerDidTapActionButton(self)
    }
}

extension SendAppreciationViewController {
    public func didCompletePurchase() {
        sendAppreciationView.numTokens = viewModel.tokens
        sendAppreciationView.actionButton.isEnabled = true
        sendAppreciationView.actionButton.setTitle("Send Appreciation", for: .normal)
        sendAppreciationView.actionButton.isLoading = false
    }
    
    public func didCancelPurchase() {
        sendAppreciationView.actionButton.isEnabled = true
        sendAppreciationView.actionButton.isLoading = false
    }
    
    public func didFailPurchase() {
        sendAppreciationView.actionButton.setTitle("Get Tokens", for: .normal)
        sendAppreciationView.actionButton.isEnabled = true
        sendAppreciationView.actionButton.isLoading = false
        showToast("Something Went Wrong.", severity: .urgent)
    }
    
    public func didFailLoadingProducts() {
        showToast("Could not load products.", severity: .urgent)
    }
}

// MARK: - Themeable

extension SendAppreciationViewController: Themeable {
    func updateColors(for theme: Theme) {
        sendAppreciationView.updateColors(for: theme)
    }
}
