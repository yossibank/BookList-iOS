final class ChatRoomViewModel {

    var messages: [String] = []

    func sendChatMessage(message: String) {
        FirestoreManager.shared.createChatMessage(message: message)
    }
}
