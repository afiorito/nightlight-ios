import Foundation

/// A view model for handling user notifications.
public class UserNotificationsViewModel {
    public typealias Dependencies = UserNotificationServiced & StyleManaging
    
    /// The required dependencies.
    private let dependencies: Dependencies
    
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
     
     - parameter result: The result of retrieving the notifications.
     */
    public func getNotifications(result: @escaping (Result<[UserNotificationViewModel], UserNotificationError>) -> Void) {
        guard !isFetchInProgress && (endPage != nil || startPage == nil) else {
            return
        }
        
        isFetchInProgress = true
        
        dependencies.notificationService.getNotifications(start: startPage, end: endPage) { [unowned self] notificationResult in
            self.isFetchInProgress = false
            
            switch notificationResult {
            case .success(let notificationResponse):
                self.startPage = notificationResponse.metadata.start
                self.endPage = notificationResponse.metadata.end
                self.totalCount = notificationResponse.metadata.total
                
                let notifications = notificationResponse.data.map { UserNotificationViewModel(userNotification: $0) }
                
                DispatchQueue.main.async { result(.success(notifications)) }
            case .failure(let error):
                DispatchQueue.main.async { result(.failure(error)) }
            }
        }
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
