import UIKit

/// A view for animating the nightlight logo.
public class AnimatedLogoView: UIView {
    
    /// An image view to displaying the logo image.
    private let logo: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.icon.logo
        imageView.tintColor = .brand
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        updateColors(for: theme)
        prepareSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     Start the logo animation.
     */
    public func startAnimation() {
        
        let transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        
        UIView.animate(withDuration: 1.0, delay: 0.5, options: [.curveEaseInOut, .repeat, .autoreverse], animations: { [weak self] in
            self?.logo.transform = transform
        })
    }
    
    /**
      Stop the logo animation by returning to original state.
      */
    public func endAnimation(completion: ((Bool) -> Void)?) {
        logo.transform = .identity
        logo.layer.removeAllAnimations()
        let transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        UIView.animate(withDuration: 0.45, delay: 0.5, options: [.curveEaseInOut, .beginFromCurrentState], animations: { [weak self] in
            self?.logo.transform = transform
            self?.alpha = 0.0
        }, completion: completion)
    }
    
    private func prepareSubviews() {
        addSubviews(logo)
        
        NSLayoutConstraint.activate([
            logo.centerXAnchor.constraint(equalTo: centerXAnchor),
            logo.centerYAnchor.constraint(equalTo: centerYAnchor),
            logo.widthAnchor.constraint(equalToConstant: 100),
            logo.heightAnchor.constraint(equalTo: logo.widthAnchor, multiplier: 1.0)
        ])
    }
}

// MARK: - Themeable

extension AnimatedLogoView: Themeable {
    func updateColors(for theme: Theme) {
        if #available(iOS 13.0, *) {
            backgroundColor = UIColor.systemBackground
        } else {
            backgroundColor = .white
        }
    }
}
