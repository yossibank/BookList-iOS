final class ChatRoomViewModel: ViewModel {
    private let roomId: String
    private let user: User
    private let firestore = FirestoreManager.shared

    var currentUserId: Int {
        user.id
    }

    init(roomId: String, user: User) {
        self.roomId = roomId
        self.user = user
    }

    func removeListener() {
        firestore.removeListner()
    }

    func fetchChatMessages(
        completion: @escaping ((FirestoreManager.documentChange, ChatMessage) -> Void)
    ) {
        firestore.fetchChatMessages(
            roomId: roomId,
            completion: completion
        )
    }

    func sendChatMessage(message: String) {
        firestore.createChatMessage(
            roomId: roomId,
            user: user,
            message: message
        )
    }
}
