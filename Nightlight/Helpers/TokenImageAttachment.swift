import UIKit

public class TokenImageAttachment: NSTextAttachment {
    
    public let font: UIFont?
    
    init(font: UIFont?) {
        self.font = font
        
        super.init(data: nil, ofType: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func attachmentBounds(for textContainer: NSTextContainer?, proposedLineFragment lineFrag: CGRect, glyphPosition position: CGPoint, characterIndex charIndex: Int) -> CGRect {
        
        guard let image = image, let font = font else {
            return super.attachmentBounds(for: textContainer, proposedLineFragment: lineFrag, glyphPosition: position, characterIndex: charIndex)
        }
        
        return CGRect(x: -1, y: (font.capHeight - image.size.height).rounded() / 2, width: image.size.width, height: image.size.height)
    }
}
