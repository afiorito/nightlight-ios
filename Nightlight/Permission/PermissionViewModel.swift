import Foundation

/// A view model for handling permissions.
public class PermissionViewModel {
    public typealias Dependencies = UserNotificationManaging & StyleManaging
    
    /// The required dependencies.
    private let dependencies: Dependencies
    
    /// The delegate object that handles user interface updates.
    public weak var uiDelegate: PermissionViewModelUIDelegate?
    
    /// The delegate object that handles navigation events.
    public weak var navigationDelegate: PermissionNavigationDelegate?
    
    public init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    /**
     Request notification autorization.
     
     - parameter result: the result of the notification authorization request.tt
     */
    public func requestNotifications() {
        dependencies.userNotificationCenter.requestAuthorization(options: [.badge, .alert, .sound]) { [weak self] (granted, error) in
            DispatchQueue.main.async {
                if !granted, let error = error {
                    self?.uiDelegate?.didFailToReceivePermission(with: error)
                    return
                }
                
                self?.uiDelegate?.didReceivePermission()
                self?.navigationDelegate?.didFinishRequestingPermission()
            }
        }
    }
    
    /**
     Reject the permission without attempting to grant it.
     */
    public func rejectPermission() {
        navigationDelegate?.didFinishRequestingPermission()
    }
}
