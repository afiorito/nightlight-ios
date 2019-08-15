/// Request body for purchasing tokens.
public struct UserTokensBody: Codable {
    let tokens: Int
    let receipt: String
}
