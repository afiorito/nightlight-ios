import UIKit

/// A view controller for managing notification permission.
public class NotificationPermissionViewController: PermissionViewController {
    
    /// The viewModel for handling state.
    private let viewModel: PermissionViewModel
    
    init(viewModel: PermissionViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        permissionView.confirmActionTitle = Strings.permission.notification.confirmTitle
        permissionView.cancelActionTitle = Strings.permission.notification.cancelTitle
        permissionView.title = Strings.permission.notification.title
        permissionView.subtitle = Strings.permission.notification.subtitle
        permissionView.imageName = "empty_notifications"
        
        super.viewDidLoad()
    }
    
    override func didConfirm() {
        viewModel.requestNotifications { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let granted):
                if granted {
                    self.delegate?.permissionViewController(self, didFinish: true)
                    return
                }
            case .failure: break
            }
            
            self.delegate?.permissionViewController(self, didFinish: false)
        }
    }
    
    override func didCancel() {
        delegate?.permissionViewController(self, didFinish: false)
    }
    
    deinit {
        removeDidChangeThemeObserver()
    }
}
