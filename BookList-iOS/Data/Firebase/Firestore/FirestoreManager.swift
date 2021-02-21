import FirebaseFirestore

final class FirestoreManager {

    private let database = Firestore.firestore()

    static let shared = FirestoreManager()

    private init() { }

    func createUser(
        documentPath: String,
        id: Int,
        email: String
    ) {
        guard
            let user = FirestoreUser(
                id: id,
                email: email
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
