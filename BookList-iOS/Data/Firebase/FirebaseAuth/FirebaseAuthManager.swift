import FirebaseAuth

final class FirebaseAuthManager {

    typealias SignupUser = SignupResponse.User

    static let shared = FirebaseAuthManager()

    var currentUser: User? {
        Auth.auth().currentUser
    }

    private init() { }

    func createUserWithFirestore(
        email: String,
        password: String,
        user: SignupUser
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

    func signIn(
        email: String,
        password: String
    ) {
        Auth.auth().signIn(
            withEmail: email,
            password: password
        ) { user, error in
            if user == nil, let error = error {
                print("userがログインに失敗しました: \(error)")
            }
            if let user = user {
                Logger.info("success signIn user: \(String(describing: user.user.email))")
            }
        }
    }

    func logout() {
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
            } catch {
                Logger.error("failed logout \(error.localizedDescription)")
            }
        } else {
            return
        }
    }
}
