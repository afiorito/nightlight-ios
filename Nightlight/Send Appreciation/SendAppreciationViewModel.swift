import Foundation

/// A view model for handling a sending appreciation.
public class SendAppreciationViewModel {
    public typealias Dependencies = KeychainManaging & PeopleServiced & MessageServiced & StyleManaging

    /// The required dependencies.
    private let dependencies: Dependencies
    
    /// The backing message model.
    private let message: Message
    
    /// The delegate object that handles user interface updates.
    public weak var uiDelegate: SendAppreciationViewModelUIDelegate?
    
    /// The delegate object that handles navigation events.
    public weak var navigationDelegate: SendAppreciationNavigationDelegate?
    
    /// The number of tokens a person has.
    var tokens: Int {
        let tokens = try? dependencies.keychainManager.integer(for: KeychainKey.tokens.rawValue)

        return tokens ?? 0
    }
    
    public init(dependencies: Dependencies, message: Message) {
        self.dependencies = dependencies
        self.message = message
    }
    
    /**
     Appreciate a message.
     
     - parameter result: the result of appreciating a message.
     */
    public func appreciateMessage() {
        guard tokens > 0 else {
            self.navigationDelegate?.showBuyTokensModal()
            return
        }
        
        dependencies.messageService.appreciate(message: message) { [weak self] (appreciateResult) in
            guard let self = self else { return }
            switch appreciateResult {
            case .success(let message):
                DispatchQueue.main.async {
                    self.navigationDelegate?.didAppreciate(message: message)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.navigationDelegate?.didFailToAppreciate(message: self.message, with: error)
                }
            }
        }
    }
    
    /**
     Update the number of tokens a user has.
     */
    public func updateTokens() {
        dependencies.peopleService.getPerson { [weak self] _ in
            self?.uiDelegate?.updateView()
        }
    }
    
    /**
     Stop sending appreciation.
     */
    public func finish() {
        navigationDelegate?.didFinishAppreciating()
    }
}

// MARK: - Navigation Events

extension SendAppreciationViewModel {
    public func didCompletePurchase() {
        uiDelegate?.didCompletePurchase()
    }
    
    public func didFailPurchase() {
        uiDelegate?.didFailPurchase()
    }
    
    public func didCancelPurchase() {
        uiDelegate?.didCancelPurchase()
    }
    
}
