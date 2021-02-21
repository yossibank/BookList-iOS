struct FirestoreUser: FirebaseModelProtocol {
    var id: Int
    var email: String

    static let collectionName = "users"
}
