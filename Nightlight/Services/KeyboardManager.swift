import UIKit

/// a protocol for being able to access KeyboardManager.
public protocol KeyboardManaging {
    var keyboardManager: KeyboardManager { get }
}

/// Responsible for managing iOS keyboard.
public class KeyboardManager {
    /// The mechanism for listening to keyboard and input changes.
    private let notificationCenter: NotificationCenter

    /// The currently active input view.
    private weak var inputView: UIView?

    /// The frame of the top view in the hierarchy.
    private var topViewBeginRect = CGRect.zero
    
    /// Returns true if keyboard is showing, false if not.
    private var isKeyboardShowing: Bool = false
    
    /// The last recorded frame of the keyboard.
    private var kbFrame = CGRect.zero
    
    /// The animation duration of the keyboard.
    private var animationDuration: TimeInterval = 0.25
    
    /// The animation curve of the keyboard.
    private var animationCurve: UIView.AnimationOptions = .curveEaseOut
    
    /// A value for margin between the input view and keyboard.
    public var keyboardDistanceFromInputView: CGFloat = 10.0
    
    /// An array of disabled classes to ignore keyboard management.
    public var disabledDistanceHandlingClasses  = [UIViewController.Type]()
    
    /// A gesture for resigning first responder when tapping outside current input view.
    private lazy var resignFirstResponderGesture: UITapGestureRecognizer = {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapRecognized(_:)))
        tapGesture.cancelsTouchesInView = false
        
        return tapGesture
    }()
    
    /// Return Tte current top-most view controller.
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
        
        disabledDistanceHandlingClasses.append(UITableViewController.self)
    }
    
    deinit {
        unregisterAllNotifications()
    }
    
    /// The key window of the application.
    private var keyWindow: UIWindow? {
        return inputView?.window ?? UIApplication.shared.keyWindow
    }
    
    /**
     Notifies the active input view that it has been asked to relinquish its status as first responder in its window.
     
     - returns: The default implementation returns true, resigning first responder status.
     */
    @discardableResult
    private func resignFirstResponder() -> Bool {
        return inputView?.resignFirstResponder() ?? false
    }
    
    /**
     Adjust the frame of the top-most view controller so that the input view is within margin distances.
     */
    private func adjustFrame() {
        guard let inputView = inputView,
            let window = keyWindow,
            let rootViewController = topViewController,
            let textFieldRect = inputView.superview?.convert(inputView.frame, to: window),
            let responderViewController = inputView.responderViewController,
            !disabledDistanceHandlingClasses.contains(where: { responderViewController.isKind(of: $0) })
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
    
    /**
     Registers all notifications necessary for responding to input view and keyboard changes.
     */
    private func registerAllNotifications() {
        notificationCenter.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardDidShow(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardDidHide(_:)), name: UIResponder.keyboardDidHideNotification, object: nil)
        
        registerInputViewClass(UITextField.self,
                               didBeginEditingNotification: UITextField.textDidBeginEditingNotification,
                               didEndEditingNotification: UITextField.textDidEndEditingNotification)
        registerInputViewClass(UITextView.self,
                                       didBeginEditingNotification: UITextView.textDidBeginEditingNotification,
                                       didEndEditingNotification: UITextView.textDidEndEditingNotification)
    }
    
    /**
     Stop observing input view and keyboard changes.
     */
    private func unregisterAllNotifications() {
        notificationCenter.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
   
        unregisterInputViewClass(UITextField.self,
                                 didBeginEditingNotification: UITextView.textDidBeginEditingNotification,
                                 didEndEditingNotification: UITextView.textDidEndEditingNotification)
        unregisterInputViewClass(UITextView.self,
                                 didBeginEditingNotification: UITextView.textDidBeginEditingNotification,
                                 didEndEditingNotification: UITextView.textDidEndEditingNotification)
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
        
        // needed to prevent textfield text from jumping
        inputView?.layoutIfNeeded()
        
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
    
    @objc private func keyboardDidShow(_ notification: Notification?) {}
    
    @objc private func keyboardWillHide(_ notification: Notification?) {
        guard inputView != nil else {
            return
        }
        
        isKeyboardShowing = false
        
        UIView.animate(withDuration: self.animationDuration, delay: 0, options: self.animationCurve.union(.beginFromCurrentState), animations: {
            self.topViewController?.view.frame = self.topViewBeginRect
        })

    }
    
    @objc private func keyboardDidHide(_ notification: Notification?) {}
    
    // MARK: - Gesture Recognizers
    
    @objc private func tapRecognized(_ gesture: UITapGestureRecognizer) {
        if gesture.state == .ended {
            resignFirstResponder()
        }
    }
}

private extension UIView {
    var responderViewController: UIViewController? {
        var nextResponder: UIResponder? = self
              
        while let next = nextResponder?.next {
            nextResponder = next
            
            if let viewController = nextResponder as? UIViewController {
                return viewController
            }
        }
        
        return nil
    }
}
