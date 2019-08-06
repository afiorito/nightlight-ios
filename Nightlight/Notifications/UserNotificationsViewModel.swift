import Foundation

public class UserNotificationsViewModel {
    
    public typealias Dependencies = UserNotificationServiced & StyleManaging
    
    private let dependencies: Dependencies
    
    public var theme: Theme {
        return dependencies.styleManager.theme
    }
    
    private var startPage: String?
    private var endPage: String?
    
    private(set) var totalCount: Int = 0
    
    private var isFetchInProgress = false
    
    public init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
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
    
    public func resetPaging() {
        startPage = nil
        endPage = nil
    }
}
