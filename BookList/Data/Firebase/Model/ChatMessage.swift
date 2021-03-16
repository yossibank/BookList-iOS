struct ChatMessage: FirebaseModelProtocol {
    var message: String
    
    static let collecitonName = "chatMessages"
}
