import FirebaseAuth

final class FirebaseAuthManager {

    typealias User = SignupResponse.User

    static let shared = FirebaseAuthManager()

    private init() { }

    func createUserWithFirestore(
        email: String,
        password: String,
        user: User
    ) {
        Auth.auth().createUser(
            withEmail: email,
            password: password
        ) { result, error in
            if let result = result {
                FirestoreManager.shared.createUser(
                    documentPath: result.user.uid,
                    id: user.id,
                    email: user.email
                )
            }
            if let error = error {
                print("user情報の登録に失敗しました: \(error)")
            }
        }
    }
}
