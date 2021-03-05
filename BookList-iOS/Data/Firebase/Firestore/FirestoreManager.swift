import FirebaseFirestore

final class FirestoreManager {

    typealias timeStamp = Timestamp

    private let database = Firestore.firestore()

    static let shared = FirestoreManager()

    private init() {}

    func createUser(
        documentPath: String,
        user: FirestoreUser
    ) {
        guard
            let user = FirestoreUser(
                id: user.id,
                name: user.name,
                email: user.email,
                imageUrl: user.imageUrl,
                createdAt: timeStamp()
            ).toDictionary()
        else {
            return
        }

        database
            .collection(FirestoreUser.collectionName)
            .document(documentPath)
            .setData(user) { error in
                if let error = error {
                    print("user情報の登録に失敗しました: \(error)")
                }
        }
    }
}
