import Foundation

/// A view model for handling app information.
public class AppInfoViewModel {
    /// The version number of the application.
    var versionNumber: String {
        let versionString = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        
        return versionString ?? ""
    }
    
    /// The build number of the application.
    var buildNumber: String {
        if let buildString = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            return "(\(buildString))"
        }
        return ""
    }
    
    /// The copyright date of the application.
    var copyrightDate: String {
        return "\(Calendar.current.component(.year, from: Date()))"
    }
}
