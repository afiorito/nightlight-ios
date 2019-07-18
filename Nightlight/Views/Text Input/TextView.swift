import UIKit

public class TextView: UITextView {
    
    private var observers = [NSKeyValueObservation]()
    
    private lazy var placeHolderTextView: UITextView = {
        let textView = UITextView()
        
        textView.textColor = .gray
        textView.isUserInteractionEnabled = false
        textView.backgroundColor = .clear
        
        return textView
    }()
    
    public var placeholder: String? {
        get {
            return placeHolderTextView.text
        }
        
        set {
            placeHolderTextView.text = newValue
            updatePlaceholder()
        }
    }
    
    public var attributedPlaceholder: NSAttributedString? {
        get {
            return placeHolderTextView.attributedText
        }
        
        set {
            placeHolderTextView.attributedText = newValue
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
    
    private func observeChange<Value>(_ textView: TextView, value: NSKeyValueObservedChange<Value>) {
        self.updatePlaceholder()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UITextView.textDidChangeNotification, object: self)
        
        for observer in observers {
            observer.invalidate()
        }
        
        observers.removeAll()
    }

    @objc private func updatePlaceholder() {
        if text.isEmpty {
            insertSubview(placeHolderTextView, at: 0)
        } else {
            placeHolderTextView.removeFromSuperview()
        }
        
        placeHolderTextView.font = self.font
        placeHolderTextView.textAlignment = textAlignment
        placeHolderTextView.textContainer.exclusionPaths = self.textContainer.exclusionPaths
        placeHolderTextView.textContainerInset = self.textContainerInset
        placeHolderTextView.textContainer.lineFragmentPadding = self.textContainer.lineFragmentPadding
        self.placeHolderTextView.frame = self.bounds
    }
    
}
