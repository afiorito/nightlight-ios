import Foundation

/// A view model for handling permissions.
public class PermissionViewModel {
    public typealias Dependencies = UserNotificationManaging & StyleManaging
    
    /// The required dependencies.
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    /**
     Request notification autorization.
     
     - parameter result: the result of the notification authorization request.tt
     */
    public func requestNotifications(result: @escaping (Result<Bool, Error>) -> Void) {
        dependencies.userNotificationCenter.requestAuthorization(options: [.badge, .alert, .sound]) { (granted, error) in
            DispatchQueue.main.async {
                if let error = error {
                    return result(.failure(error))
                }
                
                result(.success(granted))
            }
        }
    }
}
