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
    
    // A transition for presenting view controllers from below.
    private let bottomTransition = BottomTransition()
    
    /// A view controller for managing settings.
    public lazy var settingsViewController: MainSettingsViewController = {
        let viewController = MainSettingsViewController(viewModel: viewModel)
        viewController.navigationItem.leftBarButtonItem = simulatedBackButton
        viewController.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        viewController.title = Strings.setting.settingsTitle
        
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
        appInfoViewController.transitioningDelegate = bottomTransition
        
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
        let viewModel = OptionsViewModel<E>(currentOption: currentOption)
        let optionsViewController = OptionsTableViewController<E>(viewModel: viewModel)

        viewModel.navigationDelegate = self
        optionsViewController.navigationItem.leftBarButtonItem = simulatedBackButton
        
        settingsViewController.navigationController?.pushViewController(optionsViewController, animated: true)
    }
    
    public func didChangeTheme(to theme: Theme) {
        viewModel.updateTheme(theme)
    }
    
    public func didChangeMessageDefault(to default: MessageDefault) {
        viewModel.updateMessageDefault(`default`)
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
    
    public func showAccountSettings() {
        let rootViewController = settingsViewController.navigationController ?? self.rootViewController
        let coordinator = AccountSettingsCoordinator(rootViewController: rootViewController, dependencies: dependencies)
        addChild(coordinator)
        coordinator.start()
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
