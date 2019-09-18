import Foundation

/// Methods for handling UI updates from a messages view model.
public protocol UserNotificationsViewModelUIDelegate: class {
    /**
    Tells the delegate that fetching user notifications began.
    
    - parameter fromStart: A boolean denoting if the data is being fetched from the beginning of a paginated list.
    */
    func didBeginFetchingUserNotifications(fromStart: Bool)
    
    /**
     Tells the delegate that fetching user notifications stopped.
     */
    func didEndFetchingUserNotifications()
    
    /**
     Tells the delegate that fetching user notifications failed.
     
     - parameter error: The error for the fetching failure.
     */
    func didFailToFetchUserNotifications(with error: UserNotificationError)
    
    /**
     Tells the delegate the user notifications fetched successfully.
     
     - parameter count: The count of the fetched user notifications.
     - parameter fromStart: A boolean denoting if the data is being fetched from the beginning of a paginated list.
     */
    func fetchUserNotificationsDidSucceed(with count: Int, fromStart: Bool)
}
