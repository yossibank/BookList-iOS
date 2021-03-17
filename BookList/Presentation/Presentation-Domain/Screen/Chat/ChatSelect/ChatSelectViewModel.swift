final class ChatSelectViewModel {

    func fetchRooms(
        completion: @escaping ((FirestoreManager.documentChange, Room) -> Void)
    ) {
        FirestoreManager.shared.fetchRooms(completion: completion)
    }
}
