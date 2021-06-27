import Foundation

struct UUIDIdentifiable: Identifiable & Equatable {
    var id = UUID().uuidString
}
