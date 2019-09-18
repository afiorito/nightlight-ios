import UIKit

/// A view controller for managing sending appreciation.
public class SendAppreciationViewController: UIViewController {

    /// The viewModel for handling state.
    private let viewModel: SendAppreciationViewModel
    
    /// The view of the view controller.
    private var sendAppreciationView = SendAppreciationView()
    
    /// A boolean denoting if the user has tokens.
    private var hasTokens: Bool {
        return viewModel.tokens > 0
    }
    
    public init(viewModel: SendAppreciationViewModel) {
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
        
        prepareSubviews()
        updateView()
        updateColors(for: theme)
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if isBeingRemoved {
            viewModel.finish()
        }
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
    
    // MARK: - Gesture Recognizer Handlers
    
    @objc public func cancel() {
        dismiss(animated: true)
    }
    
    @objc private func actionButtonTapped() {
        sendAppreciationView.actionButton.isEnabled = false
        sendAppreciationView.actionButton.isLoading = true
        viewModel.appreciateMessage()
    }
}

// MARK: - SendAppreciationViewModel UI Delegate

extension SendAppreciationViewController: SendAppreciationViewModelUIDelegate {
    public func updateView() {
        sendAppreciationView.actionButton.setTitle(hasTokens ? Strings.sendAppreciation : Strings.getTokens, for: .normal)
        sendAppreciationView.numTokens = viewModel.tokens
    }
    
    public func didCancelPurchase() {
        sendAppreciationView.actionButton.isEnabled = true
        sendAppreciationView.actionButton.isLoading = false
    }

    public func didCompletePurchase() {
        sendAppreciationView.numTokens = viewModel.tokens
        sendAppreciationView.actionButton.isEnabled = true
        sendAppreciationView.actionButton.setTitle(Strings.sendAppreciation, for: .normal)
        sendAppreciationView.actionButton.isLoading = false
    }
    
    public func didFailPurchase() {
        sendAppreciationView.actionButton.setTitle(Strings.getTokens, for: .normal)
        sendAppreciationView.actionButton.isEnabled = true
        sendAppreciationView.actionButton.isLoading = false
        showToast(Strings.error.somethingWrong, severity: .urgent)
    }
}

// MARK: - Bottom Sheet Presentable

extension SendAppreciationViewController: BottomSheetPresentable {
    public var panScrollable: UIScrollView? {
        return nil
    }
    
    public var bottomSheetHeight: BottomSheetHeight {
        return .intrinsicHeight
    }
}

// MARK: - Themeable

extension SendAppreciationViewController: Themeable {
    func updateColors(for theme: Theme) {
        sendAppreciationView.updateColors(for: theme)
    }
}
