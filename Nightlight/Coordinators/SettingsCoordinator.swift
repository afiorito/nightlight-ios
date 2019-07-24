import UIKit

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
    
}

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
        
    }
    
    public func settingsViewControllerDidSelectRate(_ settingsViewController: SettingsViewController) {
        
    }
    
    public func settingsViewControllerDidSelectAbout(_ settingsViewController: SettingsViewController) {
        
    }
    
    public func settingsViewControllerDidSelectPrivacyPolicy(_ settingsViewController: SettingsViewController) {
        
    }
    
    public func settingsViewControllerDidSelectTermsOfUse(_ settingsViewController: SettingsViewController) {
            
        }
    
    public func settingsViewControllerDidSelectSignout(_ settingsViewController: SettingsViewController) {
        NLNotification.unauthorized.post()
    }
}

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

extension SettingsCoordinator: UIGestureRecognizerDelegate {}
