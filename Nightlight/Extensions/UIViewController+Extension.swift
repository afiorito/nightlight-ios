import UIKit

extension UIViewController {
    /**
     Adds the specified view controller as a child of the current view controller.
     
     - parameter child: The view controller to be added as a child.
     */
    public func add(child: UIViewController) {
        addChild(child)
        view.addSubviews(child.view)
        child.didMove(toParent: self)
    }
    
    /**
     Removes the  view controller from its parent.
     */
    public func remove() {
        guard parent != nil else {
            return
        }
        
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
    
    public func showToast(_ message: String, severity: ToastView.Severity, duration: TimeInterval = 6.0) -> ToastView {
        let toastView = ToastView()
        toastView.severity = severity
        toastView.message = message
        toastView.alpha = 0
        
        view.addSubviews(toastView)
        
        let height: CGFloat = 35
        let bottomConstraint = toastView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: height)
        
        NSLayoutConstraint.activate([
            toastView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            toastView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            toastView.heightAnchor.constraint(equalToConstant: 35.0),
            bottomConstraint
        ])
        
        self.view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.35, delay: 0, options: .curveEaseOut, animations: {
            bottomConstraint.constant = -30
            self.view.layoutIfNeeded()
            toastView.alpha = 1
        })

        UIView.animate(withDuration: 0.35, delay: duration + 0.35, options: .curveEaseIn, animations: {
            bottomConstraint.constant = height
            self.view.layoutIfNeeded()
            toastView.alpha = 0
        }, completion: { _ in
            toastView.removeFromSuperview()
        })
        
        return toastView
    }
}
