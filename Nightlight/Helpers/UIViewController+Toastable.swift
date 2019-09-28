import UIKit

extension UIViewController: Toastable {    
    public var toastView: ToastView? {
        return view.subview(ofType: ToastView.self)
    }
    
    @discardableResult
    public func showToast(_ message: String, severity: ToastView.Severity, duration: TimeInterval = 6.0) -> ToastView {
        if let toast = toastView {
            toast.removeFromSuperview()
        }
        
        let toastView = ToastView()
        toastView.severity = severity
        toastView.message = message
        toastView.alpha = 0
        
        let view: UIView = nextParent()?.view ?? self.view
        
        view.addSubviews(toastView)
        
        let bottomConstraint = toastView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 200)
        
        NSLayoutConstraint.activate([
            toastView.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
            toastView.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor),
            bottomConstraint
        ])
        
        view.layoutIfNeeded()
        
        if let self = self as? Themeable {
            toastView.updateColors(for: self.theme)
        }
        
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut, animations: {
            bottomConstraint.constant = -15
            view.layoutIfNeeded()
            toastView.alpha = 1
        })
        
        UIView.animate(withDuration: 0.35, delay: duration + 0.4, options: .curveEaseIn, animations: {
            bottomConstraint.constant = 200
            view.layoutIfNeeded()
            toastView.alpha = 0
        }, completion: { _ in
            toastView.removeFromSuperview()
        })
        
        return toastView
    }
}
