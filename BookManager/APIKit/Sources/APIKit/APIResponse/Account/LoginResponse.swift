public struct LoginResponse: DataStructure {
    var status: Int
    var result: User

    public struct User: DataStructure {
        var id: Int
        var email: String
        var token: String
    }
}
