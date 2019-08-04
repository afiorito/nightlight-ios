import UIKit

public class NotificationPermissionViewController: PermissionViewController {
    
    private var permissionView: PermissionView {
        return view as! PermissionView
    }
    
    private let viewModel: PermissionViewModel
    
    init(viewModel: PermissionViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        permissionView.confirmActionTitle = "Turn On Notifications"
        permissionView.cancelActionTitle = "No Thanks"
        permissionView.title = "Never miss out"
        permissionView.subtitle = "You'll get notified when someone interacts with your content."
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
