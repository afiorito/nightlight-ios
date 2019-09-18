// A constant for denoting the type of message.
public enum MessageType: String {
    /// A recently sent message.
    case recent
    
    /// A message received by the user.
    case received
    
    /// A message sent by the user.
    case sent
    
    /// A message saved by the user.
    case saved
}
