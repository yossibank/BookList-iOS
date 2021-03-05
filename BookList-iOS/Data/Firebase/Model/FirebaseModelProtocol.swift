import CodableFirebase

protocol FirebaseModelProtocol: Codable {
    func toDictionary() -> [String: Any]?
}

extension FirebaseModelProtocol {

    static func initialize(json: [String: Any]) -> Self? {
        do {
            return try FirestoreDecoder().decode(self, from: json)
        } catch {
            Logger.error(error.localizedDescription)
            return nil
        }
    }

    func toDictionary() -> [String: Any]? {
        do {
            return try FirestoreEncoder().encode(self)
        } catch {
            Logger.error(error.localizedDescription)
            return nil
        }
    }
}
