import FirebaseFirestore
import FirebaseFirestoreSwift

protocol FirebaseModelProtocol: Codable {
    func toDictionary() -> [String: Any]?
}

extension FirebaseModelProtocol {

    static func initialize(json: [String: Any]) -> Self? {
        do {
            return try Firestore.Decoder().decode(Self.self, from: json)
        } catch {
            Logger.error(error.localizedDescription)
            return nil
        }
    }

    func toDictionary() -> [String: Any]? {
        do {
            return try Firestore.Encoder().encode(self)
        } catch {
            Logger.error(error.localizedDescription)
            return nil
        }
    }
}
