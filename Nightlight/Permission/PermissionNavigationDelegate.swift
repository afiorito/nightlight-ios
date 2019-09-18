/// Methods for handling permission navigation events.
public protocol PermissionNavigationDelegate: class {
    /**
     Tells the delegate that the permission finished requesting.
     */
    func didFinishRequestingPermission()
}
