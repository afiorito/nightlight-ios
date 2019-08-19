import UIKit

/// A text view with a placeholder.
public class TextView: UITextView {
    /// An array of observers for updating the placeholder.
    private var observers = [NSKeyValueObservation]()
    
    /// A text view for displaying the placeholder.
    private lazy var placeholderTextView: UITextView = {
        let textView = UITextView()
        
        textView.textColor = .gray
        textView.isUserInteractionEnabled = false
        textView.backgroundColor = .clear
        
        return textView
    }()
    
    /// The placeholder of the text view.
    public var placeholder: String? {
        get {
            return placeholderTextView.text
        }
        
        set {
            placeholderTextView.text = newValue
            updatePlaceholder()
        }
    }
    
    /// The attributed placeholder of the text view.
    public var attributedPlaceholder: NSAttributedString? {
        get {
            return placeholderTextView.attributedText
        }
        
        set {
            placeholderTextView.attributedText = newValue
            updatePlaceholder()
        }
    }
    
    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
    
        NotificationCenter.default.addObserver(self, selector: #selector(updatePlaceholder), name: UITextView.textDidChangeNotification, object: self)
        
        observers = [
            self.observe(\.attributedText, changeHandler: observeChange),
            self.observe(\.bounds, changeHandler: observeChange),
            self.observe(\.frame, changeHandler: observeChange),
            self.observe(\.text, changeHandler: observeChange),
            self.observe(\.textAlignment, changeHandler: observeChange),
            self.observe(\.textContainerInset, changeHandler: observeChange),
            self.observe(\.textContainer.exclusionPaths, changeHandler: observeChange),
            self.observe(\.textContainer.lineFragmentPadding, changeHandler: observeChange),
            self.observe(\.font, changeHandler: observeChange)
        ]
        
        self.updatePlaceholder()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /**
     Key value observer callback for updating the placeholder.
     */
    private func observeChange<Value>(_ textView: TextView, value: NSKeyValueObservedChange<Value>) {
        self.updatePlaceholder()
    }

    /**
     Update the placeholder text view.
     */
    @objc private func updatePlaceholder() {
        if text.isEmpty {
            insertSubview(placeholderTextView, at: 0)
        } else {
            placeholderTextView.removeFromSuperview()
        }
        
        placeholderTextView.font = self.font
        placeholderTextView.textAlignment = textAlignment
        placeholderTextView.textContainer.exclusionPaths = self.textContainer.exclusionPaths
        placeholderTextView.textContainerInset = self.textContainerInset
        placeholderTextView.textContainer.lineFragmentPadding = self.textContainer.lineFragmentPadding
        self.placeholderTextView.frame = self.bounds
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UITextView.textDidChangeNotification, object: self)
        
        for observer in observers {
            observer.invalidate()
        }
        
        observers.removeAll()
    }
    
}
