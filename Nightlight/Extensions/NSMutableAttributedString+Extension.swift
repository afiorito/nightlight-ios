import Foundation

extension NSMutableAttributedString {
    /**
     Add a token attachment to an attributed string.
     
     - parameter attachment: the attachment to add to the string.
     */
    public func appendTokenAttachment(_ attachment: TokenImageAttachment) {
        self.append(NSAttributedString(attachment: attachment))
    }
}
