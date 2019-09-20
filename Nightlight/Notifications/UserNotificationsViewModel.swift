import Foundation

/// A view model for handling user notifications.
public class UserNotificationsViewModel {
    public typealias Dependencies = UserNotificationServiced & StyleManaging
    
    /// The required dependencies.
    private let dependencies: Dependencies
    
    /// The delegate object that handles user interface updates.
    public weak var uiDelegate: UserNotificationsViewModelUIDelegate?
    
    /// The fetched user notifications.
    private var userNotifications = [AnyUserNotification]()
    
    /// The active theme.
    public var theme: Theme {
        return dependencies.styleManager.theme
    }
    
    /// The start page for loading notifications.
    private var startPage: String?
    
    /// The end page for loading notifications.
    private var endPage: String?
    
    /// The total number of notifications.
    private(set) var totalCount: Int = 0
    
    /// A boolean for determing if notifications are already being fetched.
    private var isFetchInProgress = false
    
    public init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    /**
     Retrieve notifications.
     
     - parameter fromStart: A boolean denoting if the data is being fetched from the beginning of a paginated list.
     */
    public func fetchUserNotifications(fromStart: Bool) {
        if fromStart { resetPaging() }

        guard !isFetchInProgress && (endPage != nil || startPage == nil) else {
            return
        }
        
        isFetchInProgress = true
        uiDelegate?.didBeginFetchingUserNotifications(fromStart: fromStart)
        
        dependencies.notificationService.getNotifications(start: startPage, end: endPage) { [weak self] notificationResult in
            guard let self = self else { return }
            self.isFetchInProgress = false
            
            DispatchQueue.main.async { self.uiDelegate?.didEndFetchingUserNotifications() }
            
            switch notificationResult {
            case .success(let notificationResponse):
                self.startPage = notificationResponse.metadata.start
                self.endPage = notificationResponse.metadata.end
                self.totalCount = notificationResponse.metadata.total
                
                self.userNotifications = fromStart ? notificationResponse.data : self.userNotifications + notificationResponse.data
                
                DispatchQueue.main.async { self.uiDelegate?.fetchUserNotificationsDidSucceed(with: notificationResponse.data.count, fromStart: fromStart) }
            case .failure(let error):
                DispatchQueue.main.async { self.uiDelegate?.didFailToFetchUserNotifications(with: error) }
            }
        }
    }
    
    /**
     Returns a user notification as a `UserNotificationViewModel` at a specified indexPath.
     
     - parameter indexPath: The index path for the user notification.
     */
    public func userNotificationViewModel(at indexPath: IndexPath) -> UserNotificationViewModel {
        return UserNotificationViewModel(userNotification: userNotifications[indexPath.row])
    }
    
    /**
    Resets the paging.
    
    Causes notifications to be fetched from the beginning.
    */
    public func resetPaging() {
        startPage = nil
        endPage = nil
    }
}
