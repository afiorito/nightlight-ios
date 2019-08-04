import UIKit

public class PermissionViewController: UIViewController {
    
    private var permissionView: PermissionView {
        return view as! PermissionView
    }
    
    public weak var delegate: PermissionViewControllerDelegate?
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        addDidChangeThemeObserver()
        updateColors(for: theme)
        
        permissionView.cancelAction = didCancel
        permissionView.confirmAction = didConfirm
        
    }
    
    internal func didConfirm() {
        delegate?.permissionViewController(self, didFinish: true)
    }
    
    internal func didCancel() {
        delegate?.permissionViewController(self, didFinish: false)
    }
    
    deinit {
        removeDidChangeThemeObserver()
    }
    
    public override func loadView() {
        view = PermissionView()
    }
}

// MARK: - Themeable

extension PermissionViewController: Themeable {
    func updateColors(for theme: Theme) {
        permissionView.updateColors(for: theme)
    }
}
