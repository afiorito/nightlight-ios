import UIKit

public class PermissionViewController: UIViewController {
    
    var permissionView: PermissionView {
        return view as! PermissionView
    }
    
    /// The delegate for managing UI actions.
    public weak var delegate: PermissionViewControllerDelegate?
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        addDidChangeThemeObserver()
        updateColors(for: theme)
        
        permissionView.cancelAction = didCancel
        permissionView.confirmAction = didConfirm
        
    }
    
    public override func loadView() {
        view = PermissionView()
    }
    
    // MARK: - Gesture Recognizer Handles
    
    /**
     Confirm the permission.
     */
    func didConfirm() {
        delegate?.permissionViewController(self, didFinish: true)
    }
    
    /**
     Deny the permission.
     */
    func didCancel() {
        delegate?.permissionViewController(self, didFinish: false)
    }
    
    deinit {
        removeDidChangeThemeObserver()
    }
}

// MARK: - Themeable

extension PermissionViewController: Themeable {
    func updateColors(for theme: Theme) {
        permissionView.updateColors(for: theme)
    }
}
