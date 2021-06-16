import Foundation

public struct UserResponse: DataStructure {
    public let status: Int
    public let result: User

    public struct User: DataStructure {
        public let id: Int
        public let email: String
        public let token: String
    }
}
