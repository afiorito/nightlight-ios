import Foundation

public class AppInfoViewModel {
    var versionNumber: String {
        let versionString = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        
        return versionString ?? ""
    }
    
    var buildNumber: String {
        if let buildString = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            return "(\(buildString))"
        }
        return ""
    }
    
    var copyrightDate: String {
        return "\(Calendar.current.component(.year, from: Date()))"
    }
}
