import Foundation

public protocol MessageContextHandling {
    func didReportMessage(message: MessageViewModel, at indexPath: IndexPath)
    func didDeleteMessage(message: MessageViewModel, at indexPath: IndexPath)
}
