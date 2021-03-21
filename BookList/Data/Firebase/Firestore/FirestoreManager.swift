import FirebaseFirestore
import RxSwift

final class FirestoreManager {

    typealias timeStamp = Timestamp
    typealias documentChange = DocumentChange

    private let database = Firestore.firestore()
    private var listner: ListenerRegistration?

    static let shared = FirestoreManager()

    private init() {}

    func removeListner() {
        listner?.remove()
    }

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

    func findUser(
        documentPath: String,
        completion: @escaping (FirestoreUser) -> Void
    ) {
        database
            .collection(FirestoreUser.collectionName)
            .document(documentPath)
            .getDocument { querySnapshot, error in
                if let error = error {
                    print("user情報の取得に失敗しました: \(error)")
                    return
                }

                guard
                    let querySanpshot = querySnapshot,
                    let data = querySanpshot.data(),
                    let user = FirestoreUser.initialize(json: data)
                else {
                    return
                }
                completion(user)
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
                        .compactMap { FirestoreUser.initialize(json: $0.data()) }
                        .filter { $0.email != FirebaseAuthManager.shared.currentUser?.email }

                    return observer(.success(users))
                }
            return Disposables.create()
        })
    }

    // MARK: - Access for Room
    func createRoom(partnerUser: FirestoreUser) {
        findUser(documentPath: FirebaseAuthManager.shared.currentUserId) { [weak self] user in
            guard
                let self = self,
                let data = Room(
                    id: "\(user.id)\(partnerUser.id)",
                    users: [user, partnerUser],
                    lastMessage: nil,
                    lastMessageSendAt: nil,
                    createdAt: timeStamp()
                ).toDictionary()
            else {
                return
            }

            self.database
                .collection(Room.collectionName)
                .document("\(user.id)\(partnerUser.id)")
                .setData(data, merge: true) { error in
                    if let error = error {
                        print("room情報の作成に失敗しました: \(error)")
                        return
                    }
                }
        }
    }

    func fetchRooms(
        completion: @escaping ((DocumentChange, Room) -> Void)
    ) {
        listner = database
            .collection(Room.collectionName)
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print("room情報の取得に失敗しました: \(error)")
                    return
                }

                guard let querySnapshot = querySnapshot else { return }

                querySnapshot.documentChanges.forEach { snapshot in
                    guard
                        let room = Room.initialize(json: snapshot.document.data())
                    else {
                        return
                    }
                    completion(snapshot, room)
                }
            }
    }

    // MARK: - Access for ChatMessage
    func createChatMessage(roomId: String, message: String) {
        guard
            let chatMessage = ChatMessage(message: message).toDictionary()
        else {
            return
        }

        database
            .collection(Room.collectionName)
            .document(roomId)
            .collection(ChatMessage.collecitonName)
            .document()
            .setData(chatMessage) { error in
                if let error = error {
                    print("chatMessage情報の登録に失敗しました: \(error)")
                }
            }
    }
}
