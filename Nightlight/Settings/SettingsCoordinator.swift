import UIKit
import MessageUI
import SafariServices

public class SettingsCoordinator: NSObject, Coordinator {
    public typealias Dependencies = NotificationObserving & StyleManaging
    public weak var parent: Coordinator?
    
    public var children = [Coordinator]()
    
    private let dependencies: Dependencies
    
    private let rootViewController: UINavigationController
    
    private weak var buyTokensViewController: BuyTokensViewController?
    
    var simulatedBackButton: UIBarButtonItem {
        return UIBarButtonItem(image: UIImage(named: "nb_back"), style: .plain, target: self, action: #selector(goBack))
    }
    
    public lazy var settingsViewController: SettingsViewController = {
        let viewModel = SettingsViewModel(dependencies: dependencies as! SettingsViewModel.Dependencies)
        
        let viewController = SettingsViewController(viewModel: viewModel)
        viewController.navigationItem.leftBarButtonItem = simulatedBackButton
        viewController.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        viewController.delegate = self
        viewController.title = "Settings"
        rootViewController.interactivePopGestureRecognizer?.delegate = self
        
        return viewController
    }()
    
    init(rootViewController: UINavigationController, dependencies: Dependencies) {
        self.rootViewController = rootViewController
        self.dependencies = dependencies
    }
    
    deinit {
        dependencies.notificationCenter.removeObserver(self,
                                                       name: Notification.Name(rawValue: NLNotification.didFinishTransaction.rawValue),
                                                       object: nil)
    }
    
    public func start() {
        NLNotification.didFinishTransaction.observe(target: self, selector: #selector(handleFinishedTransaction))
        rootViewController.pushViewController(settingsViewController, animated: true)
    }
    
    @objc private func goBack() {
        rootViewController.popViewController(animated: true)
    }
    
    private func presentWebContentViewController(pathName: ExternalPage) {
        let webContentViewController = WebContentViewController(url: pathName.url)
        webContentViewController.title = pathName.title
        webContentViewController.delegate = self
        webContentViewController.navigationItem.leftBarButtonItem = simulatedBackButton
        
        if pathName == .about {
            webContentViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "nb_info"),
                                                                                         style: .plain,
                                                                                         target: self, action: #selector(showAppInfo))
        }
        
        rootViewController.pushViewController(webContentViewController, animated: true)
    }
    
    @objc private func handleFinishedTransaction(_ notification: Notification) {
        guard buyTokensViewController != nil,
            let outcome = notification.userInfo?[NLNotification.didFinishTransaction.rawValue] as? IAPManager.TransactionOutcome
            else { return }
        
        switch outcome {
        case .success:
            buyTokensViewController = nil
            settingsViewController.dismiss(animated: true)
            settingsViewController.didCompletePurchase()
        case .cancelled:
            buyTokensViewController?.didCancelTransaction()
        case .failed:
            buyTokensViewController = nil
            settingsViewController.dismiss(animated: true)
            settingsViewController.didFailPurchase()
        }
    }
    
    @objc private func showAppInfo() {
        let appInfoViewController = AppInfoViewController(viewModel: AppInfoViewModel())
        
        appInfoViewController.modalPresentationStyle = .custom
        appInfoViewController.modalPresentationCapturesStatusBarAppearance = true
        appInfoViewController.transitioningDelegate = ModalTransitioningDelegate.default
        
        rootViewController.present(appInfoViewController, animated: true)
    }
    
}

// MARK: - SettingsViewController Delegate

extension SettingsCoordinator: SettingsViewControllerDelegate {
    public func settingsViewControllerDidSelectAppreciation(_ settingsViewController: SettingsViewController) {
        let viewModel = BuyTokensViewModel(dependencies: dependencies as! BuyTokensViewModel.Dependencies)
        
        // need to fetch products before presenting so that collectionView has intrinsic size.
        viewModel.getProducts { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let products):
                DispatchQueue.main.async {
                    let buyTokensViewController = BuyTokensViewController(viewModel: viewModel, products: products)
                    
                    buyTokensViewController.modalPresentationStyle = .custom
                    buyTokensViewController.modalPresentationCapturesStatusBarAppearance = true
                    buyTokensViewController.transitioningDelegate = ModalTransitioningDelegate.default
                    
                    self.buyTokensViewController = buyTokensViewController
                    settingsViewController.present(buyTokensViewController, animated: true)
                }
            case .failure:
                DispatchQueue.main.async {
                    settingsViewController.didFailLoadingProducts()
                }
            }
        }
    }
    
    public func settingsViewControllerDidSelectTheme(_ settingsViewController: SettingsViewController, for currentTheme: Theme) {
        let optionsViewController = OptionsTableViewController<Theme>(currentOption: currentTheme)
        optionsViewController.title = "Theme"
        optionsViewController.delegate = self
        optionsViewController.navigationItem.leftBarButtonItem = simulatedBackButton
        
        rootViewController.pushViewController(optionsViewController, animated: true)
    }
    
    public func settingsViewControllerDidSelectDefaultMessage(_ settingsViewController: SettingsViewController, for currentMessageDefault: MessageDefault) {
        let optionsViewController = OptionsTableViewController<MessageDefault>(currentOption: currentMessageDefault)
        optionsViewController.title = "Send Message As"
        optionsViewController.delegate = self
        optionsViewController.navigationItem.leftBarButtonItem = simulatedBackButton
        
        rootViewController.pushViewController(optionsViewController, animated: true)
    }
    
    public func settingsViewControllerDidSelectFeedback(_ settingsViewController: SettingsViewController) {
        presentWebContentViewController(pathName: .feedback)
    }
    
    public func settingsViewControllerDidSelectRate(_ settingsViewController: SettingsViewController) {
        UIApplication.shared.open(URL(string: "itms-apps://itunes.apple.com/app/id1474711114")!)
    }
    
    public func settingsViewControllerDidSelectAbout(_ settingsViewController: SettingsViewController) {
        presentWebContentViewController(pathName: .about)
    }
    
    public func settingsViewControllerDidSelectPrivacyPolicy(_ settingsViewController: SettingsViewController) {
        presentWebContentViewController(pathName: .privacy)
    }
    
    public func settingsViewControllerDidSelectTermsOfUse(_ settingsViewController: SettingsViewController) {
        presentWebContentViewController(pathName: .terms)
    }
    
    public func settingsViewControllerDidSelectSignout(_ settingsViewController: SettingsViewController) {
        NLNotification.unauthorized.post()
    }
}

// MARK: - OptionsTableViewController Delegate

extension SettingsCoordinator: OptionsTableViewControllerDelegate {
    public func optionsTableViewController<E: CaseIterable & RawRepresentable>(_ optionsTableViewController: OptionsTableViewController<E>, didSelect option: E) where E.RawValue == String {
        switch E.self {
        case is Theme.Type:
            settingsViewController.didChangeTheme(to: option as! Theme)
        case is MessageDefault.Type:
            settingsViewController.didChangeMessageDefault(to: option as! MessageDefault)
        default: break
        }
    }
    
}

// MARK: - WebContentViewController Delegate

extension SettingsCoordinator: WebContentViewControllerDelegate {
    public func webContentViewController(_ webContentViewController: WebContentViewController, didNavigateTo url: URL) {
        if url.scheme == "mailto" {
            if MFMailComposeViewController.canSendMail() {
                let mail = MFMailComposeViewController()
                let email = URLComponents(url: url, resolvingAgainstBaseURL: false)?.path ?? ""
                mail.mailComposeDelegate = self
                mail.setToRecipients(email.isEmpty ? nil : [email])
                
                webContentViewController.present(mail, animated: true)
            } else {
                webContentViewController.showToast("Mail is not configured on this device.", severity: .urgent)
            }
        } else {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
            
            webContentViewController.present(SFSafariViewController(url: url, configuration: config), animated: true)
        }
    }
    
}

extension SettingsCoordinator: MFMailComposeViewControllerDelegate {
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}

extension SettingsCoordinator: UIGestureRecognizerDelegate {}
