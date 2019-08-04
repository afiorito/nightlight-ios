import Foundation

public class PermissionViewModel {
    public typealias Dependencies = UserNotificationManaging & StyleManaging
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
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
