import Combine
import DomainKit
import Foundation
import Utility

final class SignupViewModel: ViewModel {
    typealias State = LoadingState<UserEntity, APPError>

    @Published var userName = String.blank
    @Published var email = String.blank
    @Published var password = String.blank
    @Published var passwordConfirmation = String.blank
    @Published private(set) var state: State = .standby

    private let usecase: SignupUsecase

    private var cancellables: Set<AnyCancellable> = []

    init(usecase: SignupUsecase = Domain.Usecase.Account.Signup()) {
        self.usecase = usecase
    }
}

// MARK: - internal methods

extension SignupViewModel {

    func signup() {
        state = .loading

        usecase
            .signup(email: email, password: password)
            .sink { [weak self] completion in
                guard let self = self else { return }

                switch completion {
                    case let .failure(error):
                        Logger.debug(message: error.localizedDescription)
                        self.state = .failed(.init(error: error))

                    case .finished:
                        Logger.debug(message: "finished")
                }
            } receiveValue: { [weak self] state in
                self?.state = .done(state)
            }
            .store(in: &cancellables)
    }

    func createUserForFirebase(user: User) {
        FirebaseAuthManager.shared.createUser(
            email: email,
            password: password,
            user: user
        )
    }

    func saveUserIconImage(
        path: String,
        uploadImage: Data
    ) {
        FirebaseStorageManager.shared.saveUserIconImage(
            path: path,
            uploadImage: uploadImage
        )
    }

    func fetchDownloadUrlString(
        path: String,
        completion: @escaping (String) -> Void
    ) {
        FirebaseStorageManager.shared.fetchDownloadUrlString(
            path: path,
            completion: completion
        )
    }
}
