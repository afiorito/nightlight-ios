/// Request body for changing password.
public struct ChangePasswordBody: Codable {
    let oldPassword: String
    let newPassword: String
}
