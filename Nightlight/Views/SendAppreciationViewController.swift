import UIKit

public class SendAppreciationViewController: UIViewController {

    private let viewModel: SendAppreciationViewModel
    
    private weak var delegate: SendAppreciationViewControllerDelegate?
    
    private var sendAppreciationView = SendAppreciationView()
    
    init(viewModel: SendAppreciationViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()

//        sendAppreciationView.cancelButton.addTarget(self, action: #selector(cancelPurchase), for: .touchUpInside)
        sendAppreciationView.actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        
        sendAppreciationView.numTokens = viewModel.numTokens
        
        
        sendAppreciationView.actionButton.setTitle(viewModel.numTokens == 0 ? "Get Tokens" : "Send Appreciation", for: .normal)
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
    
    public func appreciateMessage() {
        viewModel.appreciateMessage { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let isAppreciated):
                if isAppreciated {
                    self.delegate?.sendAppreciationViewControllerDidAppreciate(self)
                }
            case .failure:
                self.delegate?.sendAppreciationViewControllerDidFailAppreciate(self)
            }
        }
    }
    
    @objc public func cancelPurchase() {
        dismiss(animated: true)
    }
    
    @objc private func actionButtonTapped() {
        delegate?.sendAppreciationViewControllerDidTapActionButton(self)
    }
}

extension SendAppreciationViewController: Themeable {
    func updateColors(for theme: Theme) {
        sendAppreciationView.updateColors(for: theme)
    }
}
