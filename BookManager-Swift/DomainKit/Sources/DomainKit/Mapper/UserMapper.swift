import APIKit

public struct UserMapper {

    func convert(response: Repos.Result<UserResponse>) -> UserEntity {
        UserEntity(
            id: response.result.id,
            email: response.result.email,
            token: response.result.token
        )
    }
}
