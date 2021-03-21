final class ChatRoomViewModel {

    private let roomId: String
    private let user: FirestoreUser

    var messages: [String] = []

    init(roomId: String, user: FirestoreUser) {
        self.roomId = roomId
        self.user = user
    }

    func sendChatMessage(message: String) {
        FirestoreManager.shared.createChatMessage(
            roomId: roomId,
            message: message
        )
    }
}
