struct ChatMessage: FirebaseModelProtocol {
    var id: Int
    var name: String
    var message: String
    var sendAt: FirestoreManager.timeStamp?

    static let collecitonName = "chatMessages"
}
