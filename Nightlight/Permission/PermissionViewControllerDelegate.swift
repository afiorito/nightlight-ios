/// Methods for handling UI actions occurring in a permission view controller.
public protocol PermissionViewControllerDelegate: class {
    func permissionViewController(_ permissionViewController: PermissionViewController, didFinish success: Bool)
}
