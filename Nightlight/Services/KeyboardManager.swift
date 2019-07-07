import UIKit

public protocol KeyboardManaging {
    var keyboardManager: KeyboardManager { get set }
}

/// Responsible for managing iOS keyboard
public class KeyboardManager {
    private let notificationCenter: NotificationCenter

    private weak var inputView: UIView?

    private var topViewBeginRect = CGRect.zero
    
    private var isKeyboardShowing: Bool = false
    
    private var kbFrame = CGRect.zero
    
    private var animationDuration: TimeInterval = 0.25
    private var animationCurve: UIView.AnimationOptions = .curveEaseOut
    
    /// Value for margin between the input view and keyboard
    public var keyboardDistanceFromInputView: CGFloat = 10.0
    
    private lazy var resignFirstResponderGesture: UITapGestureRecognizer = {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapRecognized(_:)))
        tapGesture.cancelsTouchesInView = false
        
        return tapGesture
    }()
    
    private var topViewController: UIViewController? {
        guard var topViewController = keyWindow?.rootViewController else {
            return nil
        }
        
        while let presentedViewController = topViewController.presentedViewController {
            topViewController = presentedViewController
        }
        
        return topViewController
    }
    
    /**
     Initialize an instance of the keyboard manager
     
     - parameter notificationCenter: main mechanism for handling keyboard changes
     */
    public init(notificationCenter: NotificationCenter = .default) {
        self.notificationCenter = notificationCenter

        registerAllNotifications()
    }
    
    deinit {
        unregisterAllNotifications()
    }
    
    private var keyWindow: UIWindow? {
        return inputView?.window ?? UIApplication.shared.keyWindow
    }
    
    private func resignFirstResponder() -> Bool {
        return inputView?.resignFirstResponder() ?? false
    }
    
    private func adjustFrame() {
        guard let inputView = inputView,
            let window = keyWindow,
            let rootViewController = topViewController,
            let textFieldRect = inputView.superview?.convert(inputView.frame, to: window)
            else { return }
        
        isKeyboardShowing = true
        
        var rootViewRect = rootViewController.view.frame
        let move = textFieldRect.maxY - window.frame.height + kbFrame.size.height
        
        if move >= 0 {
            rootViewRect.origin.y -= move
        } else {
            let disturbanceDistance = rootViewRect.minY - topViewBeginRect.minY
            
            if disturbanceDistance < 0 {
                rootViewRect.origin.y -= max(move, disturbanceDistance)
            }
            
        }
        
        UIView.animate(withDuration: self.animationDuration, delay: 0, options: self.animationCurve.union(.beginFromCurrentState), animations: {
            rootViewController.view.frame = rootViewRect
        })
        
    }
    
    // MARK: - Notification Management
    
    private func registerAllNotifications() {
        notificationCenter.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardDidShow(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardDidHide(_:)), name: UIResponder.keyboardDidHideNotification, object: nil)
        
        registerInputViewClass(UITextField.self,
                               didBeginEditingNotification: UITextField.textDidBeginEditingNotification,
                               didEndEditingNotification: UITextField.textDidEndEditingNotification)
    }
    
    private func unregisterAllNotifications() {
        notificationCenter.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    /**
     Add a Notification for a TextField/TextView class.
     
     - parameter aClass: The TextField/TextView class
     - parameter didBeginEditingNotification: The notification when the TextField/TextView begins editing
     - parameter didEndEditingNotificationName: The notification when the TextField/TextView ends editing
     */
    public func registerInputViewClass(_ aClass: UIView.Type, didBeginEditingNotification: Notification.Name, didEndEditingNotification: Notification.Name) {
        notificationCenter.addObserver(self, selector: #selector(inputViewDidBeginEditing(_:)), name: didBeginEditingNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(inputViewDidEndEditing(_:)), name: didEndEditingNotification, object: nil)
        
    }
    
    /**
     Remove a Notification for a TextField/TextView class.
     
     - parameter aClass: The TextField/TextView class
     - parameter didBeginEditingNotification: The notification when the TextField/TextView begins editing
     - parameter didEndEditingNotificationName: The notification when the TextField/TextView ends editing
     */
    public func unregisterInputViewClass(_ aClass: UIView.Type, didBeginEditingNotification: Notification.Name, didEndEditingNotification: Notification.Name) {
        notificationCenter.removeObserver(self, name: didBeginEditingNotification, object: nil)
        notificationCenter.removeObserver(self, name: didEndEditingNotification, object: nil)
    }
    
    @objc private func inputViewDidBeginEditing(_ notification: Notification) {
        inputView = notification.object as? UIView
        
        inputView?.window?.addGestureRecognizer(resignFirstResponderGesture)
        
        if !isKeyboardShowing {
            topViewBeginRect = topViewController?.view.frame ?? .zero
        }
        
        self.adjustFrame()
        
    }
    
    @objc private func inputViewDidEndEditing(_ notification: Notification) {
        inputView?.window?.removeGestureRecognizer(resignFirstResponderGesture)
        
        inputView = nil
    }
    
    @objc private func keyboardWillShow(_ notification: Notification?) {
        
        if let info = notification?.userInfo {
            if let curve = info[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt {
                self.animationCurve = .init(rawValue: curve)
            }
            
            if let duration = info[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval, duration != 0.0 {
                self.animationDuration = duration
            }
            
            if let kbFrame = info[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                self.kbFrame = kbFrame
            }
        }
        
        kbFrame.size.height += keyboardDistanceFromInputView
        
        self.adjustFrame()
    }
    
    @objc private func keyboardDidShow(_ notification: Notification?) {
    }
    
    @objc private func keyboardWillHide(_ notification: Notification?) {
        guard inputView != nil else {
            return
        }
        
        isKeyboardShowing = false
        
        UIView.animate(withDuration: self.animationDuration, delay: 0, options: self.animationCurve.union(.beginFromCurrentState), animations: {
            self.topViewController?.view.frame = self.topViewBeginRect
        })

    }
    
    @objc private func keyboardDidHide(_ notification: Notification?) {
    }
    
    // MARK: - Gesture Recognizers
    
    @objc private func tapRecognized(_ gesture: UITapGestureRecognizer) {
        if gesture.state == .ended {
            _ = resignFirstResponder()
        }
    }
}
