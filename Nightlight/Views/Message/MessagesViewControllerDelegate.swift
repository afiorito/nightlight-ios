import Foundation

public protocol MessagesViewControllerDelegate: class {
    func messagesViewController(_ messagesViewController: MessagesViewController, didSelect message: MessageViewModel)
    func messagesViewController(_ messagesViewController: MessagesViewController, moreContextFor message: MessageViewModel)
}
