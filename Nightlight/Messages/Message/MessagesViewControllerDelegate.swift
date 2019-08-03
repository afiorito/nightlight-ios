import Foundation

public protocol MessagesViewControllerDelegate: class {
    func messagesViewController(_ messagesViewController: MessagesViewController, didSelect message: MessageViewModel, at indexPath: IndexPath)
    func messagesViewController(_ messagesViewController: MessagesViewController, moreContextFor message: MessageViewModel, at indexPath: IndexPath)
    func messagesViewController(_ messagesViewController: MessagesViewController, didAppreciate message: MessageViewModel, at indexPath: IndexPath)
    func messagesViewControllerAppreciation(_ messagesViewController: MessagesViewController, didComplete complete: Bool)
}
