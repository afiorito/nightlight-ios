public class SettingsViewModel {
    public typealias Dependencies = UserDefaultsManaging & StyleManaging
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    var theme: Theme {
        return dependencies.styleManager.theme
    }
    
    var messageDefault: MessageDefault {
        return dependencies.userDefaultsManager.messageDefault
    }
    
    public func updateTheme(_ theme: Theme) {
        dependencies.userDefaultsManager.theme = theme
        dependencies.styleManager.theme = theme
    }
    
    public func updateMessageDefault(_ default: MessageDefault) {
        dependencies.userDefaultsManager.messageDefault = `default`
    }
}
