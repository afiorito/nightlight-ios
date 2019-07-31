import Foundation

extension NSMutableAttributedString {
    public func appendTokenAttachment(_ attachment: TokenImageAttachment) {
        self.append(NSAttributedString(attachment: attachment))
    }
}
