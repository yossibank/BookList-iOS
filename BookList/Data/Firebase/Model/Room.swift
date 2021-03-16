struct Room: FirebaseModelProtocol  {
    var users: [FirestoreUser]
    var lastMessage: String
    var createdAt: FirestoreManager.timeStamp

    static let collectionName = "rooms"
}
