struct Room: FirebaseModelProtocol  {
    var id: String
    var users: [FirestoreUser]
    var lastMessage: String?
    var lastMessageSendAt: FirestoreManager.timeStamp?
    var createdAt: FirestoreManager.timeStamp

    static let collectionName = "rooms"
}
