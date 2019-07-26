import UIKit
import MessageUI
import SafariServices

public class SettingsCoordinator: NSObject, Coordinator {
    public typealias Dependencies = StyleManaging
    public weak var parent: Coordinator?
    
    public var children = [Coordinator]()
    
    private let dependencies: Dependencies
    
    private let rootViewController: UINavigationController
    
    public lazy var settingsViewController: SettingsViewController = {
        let viewModel = SettingsViewModel(dependencies: dependencies as! SettingsViewModel.Dependencies)
        
        let viewController = SettingsViewController(viewModel: viewModel)
        viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "nb_back"),
                                                                          style: .plain,
                                                                          target: self,
                                                                          action: #selector(goBack))
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
    
    public func start() {
        rootViewController.pushViewController(settingsViewController, animated: true)
    }
    
    @objc private func goBack() {
        rootViewController.popViewController(animated: true)
    }
    
    private func presentWebContentViewController(pathName: ContentPathName) {
        let webContentViewController = WebContentViewController(url: pathName.url)
        webContentViewController.title = pathName.title
        webContentViewController.delegate = self
        
        rootViewController.pushViewController(webContentViewController, animated: true)
    }
    
}

// MARK: - SettingsViewController Delegate

extension SettingsCoordinator: SettingsViewControllerDelegate {
    public func settingsViewControllerDidSelectTheme(_ settingsViewController: SettingsViewController, for currentTheme: Theme) {
        let optionsViewController = OptionsTableViewController<Theme>(currentOption: currentTheme)
        optionsViewController.title = "Theme"
        optionsViewController.delegate = self
        
        rootViewController.pushViewController(optionsViewController, animated: true)
    }
    
    public func settingsViewControllerDidSelectDefaultMessage(_ settingsViewController: SettingsViewController, for currentMessageDefault: MessageDefault) {
        let optionsViewController = OptionsTableViewController<MessageDefault>(currentOption: currentMessageDefault)
        optionsViewController.title = "Send Message (Default)"
        optionsViewController.delegate = self
        
        rootViewController.pushViewController(optionsViewController, animated: true)
    }
    
    public func settingsViewControllerDidSelectFeedback(_ settingsViewController: SettingsViewController) {
        presentWebContentViewController(pathName: .feedback)
    }
    
    public func settingsViewControllerDidSelectRate(_ settingsViewController: SettingsViewController) {
        
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
