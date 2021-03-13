import FirebaseFirestore
import RxSwift

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
}
