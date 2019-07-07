import Foundation

public struct DependencyContainer: StyleManaging, UserDefaultsManaging, KeyboardManaging {
    public var styleManager = StyleManager()
    public var userDefaultsManager = UserDefaultsManager()
    public var keyboardManager = KeyboardManager()
}
