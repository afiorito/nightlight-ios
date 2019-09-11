import UIKit
import MessageUI
import SafariServices

/// A coordinator for settings flow.
public class SettingsCoordinator: NSObject, Coordinator {
    public typealias Dependencies = NotificationObserving & StyleManaging
    public weak var parent: Coordinator?
    public var children = [Coordinator]()
    
    /// The required dependencies.
    private let dependencies: Dependencies
    
    /// The root view controller of the settings view controller.
    private let rootViewController: UINavigationController
    
    /// A view controller for buying tokens.
    private weak var buyTokensViewController: BuyTokensViewController?
    
    var simulatedBackButton: UIBarButtonItem {
        return UIBarButtonItem(image: UIImage.icon.back, style: .plain, target: self, action: #selector(pop))
    }
    
    /// A view controller for managing settings.
    public lazy var settingsViewController: SettingsViewController = {
        let viewModel = SettingsViewModel(dependencies: dependencies as! SettingsViewModel.Dependencies)
        
        let viewController = SettingsViewController(viewModel: viewModel)
        viewController.navigationItem.leftBarButtonItem = simulatedBackButton
        viewController.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        viewController.delegate = self
        viewController.title = Strings.setting.settingTitle
        rootViewController.interactivePopGestureRecognizer?.delegate = self
        
        return viewController
    }()
    
    init(rootViewController: UINavigationController, dependencies: Dependencies) {
        self.rootViewController = rootViewController
        self.dependencies = dependencies
    }
    
    public func start() {
        NLNotification.didFinishTransaction.observe(target: self, selector: #selector(handleFinishedTransaction))
        
        if UIDevice.current.userInterfaceIdiom != .pad {
            settingsViewController.navigationItem.leftBarButtonItem = simulatedBackButton
            rootViewController.pushViewController(settingsViewController, animated: true)
        } else {
            settingsViewController.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.icon.cancel,
                                                                                      style: .plain,
                                                                                      target: self, action: #selector(goBack))
            let viewController = MainNavigationController(rootViewController: settingsViewController)
            viewController.modalPresentationStyle = .formSheet
            rootViewController.present(viewController, animated: true)
        }
    }
    
    /**
     Present a view controller to display web content such as a privacy \ policy page.
     
     - parameter path: the page to load web content for.
     */
    private func presentWebContentViewController(page: ExternalPage) {
        let webContentViewController = WebContentViewController(url: page.url)
        webContentViewController.title = page.title
        webContentViewController.delegate = self
        webContentViewController.navigationItem.leftBarButtonItem = simulatedBackButton
        
        if page == .about {
            webContentViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.icon.info, style: .plain,
                                                                                         target: self, action: #selector(showAppInfo))
        }
        
        settingsViewController.navigationController?.pushViewController(webContentViewController, animated: true)
    }
    
    /**
     Handle the finished transaction notification.
     
     - parameter notification: an instance of a finish transaction notification.
     */
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
    
    /**
     Display the app information view controller.
     */
    @objc private func showAppInfo() {
        let appInfoViewController = AppInfoViewController(viewModel: AppInfoViewModel())
        
        appInfoViewController.modalPresentationStyle = .custom
        appInfoViewController.modalPresentationCapturesStatusBarAppearance = true
        appInfoViewController.transitioningDelegate = ModalTransitioningDelegate.default
        
        settingsViewController.present(appInfoViewController, animated: true)
    }
    
    @objc private func goBack() {
        settingsViewController.dismiss(animated: true)
    }
    
    @objc private func pop() {
        settingsViewController.navigationController?.popViewController(animated: true)
    }
    
    deinit {
        let nc = dependencies.notificationCenter
        nc.removeObserver(self, name: Notification.Name(rawValue: NLNotification.didFinishTransaction.rawValue), object: nil)
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
        optionsViewController.title = Strings.setting.theme
        optionsViewController.delegate = self
        optionsViewController.navigationItem.leftBarButtonItem = simulatedBackButton
        
        settingsViewController.navigationController?.pushViewController(optionsViewController, animated: true)
    }
    
    public func settingsViewControllerDidSelectDefaultMessage(_ settingsViewController: SettingsViewController, for currentMessageDefault: MessageDefault) {
        let optionsViewController = OptionsTableViewController<MessageDefault>(currentOption: currentMessageDefault)
        optionsViewController.title = Strings.setting.sendMessage
        optionsViewController.delegate = self
        optionsViewController.navigationItem.leftBarButtonItem = simulatedBackButton
        
        settingsViewController.navigationController?.pushViewController(optionsViewController, animated: true)
    }
    
    public func settingsViewControllerDidSelectFeedback(_ settingsViewController: SettingsViewController) {
        presentWebContentViewController(page: .feedback)
    }
    
    public func settingsViewControllerDidSelectRate(_ settingsViewController: SettingsViewController) {
        UIApplication.shared.open(URL(string: "itms-apps://itunes.apple.com/app/id1474711114")!)
    }
    
    public func settingsViewControllerDidSelectAbout(_ settingsViewController: SettingsViewController) {
        presentWebContentViewController(page: .about)
    }
    
    public func settingsViewControllerDidSelectPrivacyPolicy(_ settingsViewController: SettingsViewController) {
        presentWebContentViewController(page: .privacy)
    }
    
    public func settingsViewControllerDidSelectTermsOfUse(_ settingsViewController: SettingsViewController) {
        presentWebContentViewController(page: .terms)
    }
    
    public func settingsViewControllerDidSelectSignout(_ settingsViewController: SettingsViewController) {
        UIApplication.shared.unregisterForRemoteNotifications()
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
                webContentViewController.showToast(Strings.error.mailNotConfigured, severity: .urgent)
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
