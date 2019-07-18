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
        
        let height: CGFloat = 35
        let bottomConstraint = toastView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: height)
        
        NSLayoutConstraint.activate([
            toastView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            toastView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            toastView.heightAnchor.constraint(equalToConstant: 35.0),
            bottomConstraint
        ])
        
        view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.35, delay: 0, options: .curveEaseOut, animations: {
            bottomConstraint.constant = -15
            view.layoutIfNeeded()
            toastView.alpha = 1
        })
        
        UIView.animate(withDuration: 0.35, delay: duration + 0.35, options: .curveEaseIn, animations: {
            bottomConstraint.constant = height
            view.layoutIfNeeded()
            toastView.alpha = 0
        }, completion: { _ in
            toastView.removeFromSuperview()
        })
        
        return toastView
    }
}
