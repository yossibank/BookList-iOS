struct SignupResponse: DataStructure {
    var status: Int
    var result: User

    struct User: DataStructure {
        var id: Int
        var email: String
        var token: String
    }
}
