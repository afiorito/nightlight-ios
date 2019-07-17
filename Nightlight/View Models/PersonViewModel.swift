import Foundation

public class PersonViewModel {
    
    private let user: User
    
    public init(user: User) {
        self.user = user
    }
    
    var username: String {
        return user.username
    }
    
    var helpingSince: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM YYYY"
        return "Helping since \(formatter.string(from: user.createdAt))"
    }
    
    var totalLove: Int {
        return user.totalLove
    }
    
    var totalAppreciation: Int {
        return user.totalAppreciation
    }
}
