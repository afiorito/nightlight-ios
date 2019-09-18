import Foundation

/// Methods for updating the user interface from a `PermissionViewModel`.
public protocol PermissionViewModelUIDelegate: class {
    /**
     Tells the delegate that the permission got granted.
     */
    func didReceivePermission()
    
    /**
     Tells the delegate that the permission failed to be granted.
     
     - parameter error: The error for the permission grant failure.
     */
    func didFailToReceivePermission(with error: Error)
}
