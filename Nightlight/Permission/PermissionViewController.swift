import UIKit

open class PermissionViewController: UIViewController {
    /// The viewModel for handling state.
    internal let viewModel: PermissionViewModel
    
    /// The view that the `PermissionViewController` manages.
    var permissionView: PermissionView {
        return view as! PermissionView
    }
    
    public init(viewModel: PermissionViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    func didConfirm() {}
    
    /**
     Deny the permission.
     */
    func didCancel() {}
    
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
