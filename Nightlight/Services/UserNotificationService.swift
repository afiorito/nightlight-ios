import Foundation

public protocol UserNotificationServiced {
    var notificationService: UserNotificationService { get }
}

/// A service for handling user notifications.
public class UserNotificationService {
    private let httpClient: HttpClient
    
    init(httpClient: HttpClient) {
        self.httpClient = httpClient
    }
    
    /**
     Retrieve notifications
     
     - parameter start: the starting cursor of the user notifications request.
     - parameter end: the ending cursor of the user notifications request.
     - parameter result: the result of retrieving the user notifications.
     */
    public func getNotifications(start: String?, end: String?, result: @escaping (Result<PaginatedResponse<AnyUserNotification>, UserNotificationError>) -> Void) {
        httpClient.get(endpoint: Endpoint.notification(start: start, end: end)) { networkResult in
            switch networkResult {
            case .success(_, let data):
                guard let notificationResponse: PaginatedResponse<AnyUserNotification> = try? data.decodeJSON() else {
                    return result(.failure(.unknown))
                }
                
                result(.success(notificationResponse))
                
            case .failure:
                result(.failure(.unknown))
            }
        }
    }
}
