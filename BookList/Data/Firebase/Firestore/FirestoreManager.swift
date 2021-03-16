import FirebaseFirestore
import RxSwift

final class FirestoreManager {

    typealias timeStamp = Timestamp

    private let database = Firestore.firestore()

    static let shared = FirestoreManager()

    private init() {}

    // MARK: - Access for User
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

    func fetchUsers() -> Single<[FirestoreUser]> {
        return Single.create(subscribe: { [weak self] observer -> Disposable in
            self?.database
                .collection(FirestoreUser.collectionName)
                .getDocuments { querySnapshot, error in
                    if let error = error {
                        print("user情報の取得に失敗しました: \(error)")
                        observer(.failure(error))
                        return
                    }

                    guard
                        let querySnapshot = querySnapshot
                    else {
                        return
                    }

                    let users = querySnapshot
                        .documents
                        .compactMap {
                            FirestoreUser.initialize(json: $0.data())
                        }

                    return observer(.success(users))
                }
            return Disposables.create()
        })
    }

    // MARK: - Access for ChatMessage
    func createChatMessage(message: String) {
        guard
            let chatMessage = ChatMessage(message: message).toDictionary()
        else {
            return
        }

        database
            .collection(ChatMessage.collecitonName)
            .document()
            .setData(chatMessage) { error in
                if let error = error {
                    print("chatMessage情報の登録に失敗しました: \(error)")
                }
            }
    }
}
