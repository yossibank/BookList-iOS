struct FirestoreUser: FirebaseModelProtocol {
    var id: Int
    var name: String
    var email: String
    var imageUrl: String
    var createdAt: FirestoreManager.timeStamp?

    static let collectionName = "users"
}
