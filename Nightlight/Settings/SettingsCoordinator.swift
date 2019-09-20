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
    
    /// The view model for managing the state of the view.
    private lazy var viewModel: SettingsViewModel = {
        SettingsViewModel(dependencies: dependencies as! SettingsViewModel.Dependencies)
    }()
    
    /// A view controller for managing settings.
    public lazy var settingsViewController: SettingsViewController = {
        let viewController = SettingsViewController(viewModel: viewModel)
        viewController.navigationItem.leftBarButtonItem = simulatedBackButton
        viewController.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        viewController.title = Strings.setting.settingTitle
        
        viewModel.uiDelegate = viewController
        viewModel.navigationDelegate = self
        
        return viewController
    }()
    
    public init(rootViewController: UINavigationController, dependencies: Dependencies) {
        self.rootViewController = rootViewController
        self.dependencies = dependencies
    }
    
    public func start() {        
        if UIDevice.current.userInterfaceIdiom != .pad {
            settingsViewController.navigationItem.leftBarButtonItem = simulatedBackButton
            rootViewController.interactivePopGestureRecognizer?.delegate = self
            rootViewController.pushViewController(settingsViewController, animated: true)
        } else {
            settingsViewController.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.icon.cancel, style: .plain, target: self, action: #selector(goBack))
            let viewController = MainNavigationController(rootViewController: settingsViewController)
            viewController.modalPresentationStyle = .formSheet
            rootViewController.present(viewController, animated: true)
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
}

// MARK: - Settings Navigation Delegate

extension SettingsCoordinator: SettingsNavigationDelegate {
    public func showBuyTokensModal() {
        let coordinator = BuyTokensCoordinator(rootViewController: settingsViewController, dependencies: dependencies)
        coordinator.navigationDelegate = self
        addChild(coordinator)
        coordinator.start()
    }
    
    public func changeSetting<E: RawRepresentable & CaseIterable>(_ type: E.Type, currentOption: E) where E.RawValue == String {
        let optionsViewController = OptionsTableViewController<E>(currentOption: currentOption)
        // split settings option by uppercase letters.
        optionsViewController.title = "\(type)".splitBefore(separator: { $0.isUppercase }).map { String($0) }.joined(separator: " ")
        optionsViewController.delegate = self
        optionsViewController.navigationItem.leftBarButtonItem = simulatedBackButton
        
        settingsViewController.navigationController?.pushViewController(optionsViewController, animated: true)
    }
    
    public func showPage(_ page: ExternalPage) {
        let webContentViewController = WebContentViewController(url: page.url)
        webContentViewController.title = page.title
        webContentViewController.delegate = self
        webContentViewController.navigationItem.leftBarButtonItem = simulatedBackButton
        
        if page == .about {
            webContentViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.icon.info, style: .plain, target: self, action: #selector(showAppInfo))
        }
        
        settingsViewController.navigationController?.pushViewController(webContentViewController, animated: true)
    }
    
    public func rateApplication() {
        guard let url = URL(string: "itms-apps://itunes.apple.com/app/id1474711114") else { return }
        UIApplication.shared.open(url)
    }
    
    public func signOut() {
        UIApplication.shared.unregisterForRemoteNotifications()
        NLNotification.unauthorized.post()
    }
    
    public func didFinishViewingSettings() {
        settingsViewController.dismiss(animated: true)
        parent?.childDidFinish(self)
    }
    
}

// MARK: - BuyTokensCoordinator Navigation Delegate

extension SettingsCoordinator: BuyTokensCoordinatorNavigationDelegate {
    public func buyTokensCoordinatorDismiss(with outcome: IAPManager.TransactionOutcome) {
        switch outcome {
        case .success: viewModel.didCompletePurchase()
        case .failed: viewModel.didFailPurchase()
        case .cancelled: viewModel.didCancelPurchase()
        }
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

// MARK: - MFMailComposeViewController Delegate

extension SettingsCoordinator: MFMailComposeViewControllerDelegate {
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}

extension SettingsCoordinator: UIGestureRecognizerDelegate {}
