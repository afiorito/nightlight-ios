import UIKit

/// A view controller for managing notification permission.
public class NotificationPermissionViewController: PermissionViewController {
    override public func viewDidLoad() {
        permissionView.confirmActionTitle = Strings.permission.notification.confirmTitle
        permissionView.cancelActionTitle = Strings.permission.notification.cancelTitle
        permissionView.title = Strings.permission.notification.title
        permissionView.subtitle = Strings.permission.notification.subtitle
        permissionView.image = UIImage.empty.notification
        
        super.viewDidLoad()
    }
    
    override func didConfirm() {
        viewModel.requestNotifications()
    }
    
    override func didCancel() {
        viewModel.rejectPermission()
    }
    
    deinit {
        removeDidChangeThemeObserver()
    }
}

// MARK: - PermissionViewModel UI Delegate

extension NotificationPermissionViewController: PermissionViewModelUIDelegate {
    public func didReceivePermission() {}
    public func didFailToReceivePermission(with error: Error) {}
}
