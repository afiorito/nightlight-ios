import UIKit

/// A protocol for view controllers that display toasts.
public protocol Toastable {
    var toastView: ToastView? { get }
    
    func showToast(_ message: String, severity: ToastView.Severity, duration: TimeInterval) -> ToastView
}
