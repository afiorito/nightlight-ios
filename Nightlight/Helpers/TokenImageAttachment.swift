import UIKit

/// An text attachment for nightlight tokens.
public class TokenImageAttachment: NSTextAttachment {
    /// The font of the text for attachment.
    public let font: UIFont?
    
    init(font: UIFont?) {
        self.font = font
        
        super.init(data: nil, ofType: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func attachmentBounds(for textContainer: NSTextContainer?, proposedLineFragment lineFrag: CGRect, glyphPosition position: CGPoint, characterIndex charIndex: Int) -> CGRect {
        guard  let font = font else {
            return super.attachmentBounds(for: textContainer, proposedLineFragment: lineFrag, glyphPosition: position, characterIndex: charIndex)
        }
        
        let height = font.lineHeight * 0.75
        
        return CGRect(x: -1, y: (font.capHeight - height).rounded() / 2, width: height, height: height)
    }
}
