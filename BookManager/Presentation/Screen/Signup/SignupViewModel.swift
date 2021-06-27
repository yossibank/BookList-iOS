import Combine
import DomainKit
import Foundation
import Utility

final class SignupViewModel: ViewModel {
    typealias State = LoadingState<UserEntity, APPError>
    typealias FireStorageState = LoadingState<String, Error>

    @Published var userName = String.blank
    @Published var email = String.blank
    @Published var password = String.blank
    @Published var passwordConfirmation = String.blank
    @Published private(set) var state: State = .standby
    @Published private(set) var fireStorageState: FireStorageState = .standby

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
                switch completion {
                    case let .failure(error):
                        self?.state = .failed(.init(error: error))

                    case .finished:
                        Logger.debug(message: "finished")
                }
            } receiveValue: { [weak self] state in
                self?.state = .done(state)
            }
            .store(in: &cancellables)
    }

    func saveUserIconImage(uploadImage: Data) {
        fireStorageState = .loading

        FirebaseStorageManager.saveUserIconImage(
            path: email,
            uploadImage: uploadImage
        )
        .sink { [weak self] compleiton in
            switch compleiton {
                case let .failure(error):
                    self?.fireStorageState = .failed(error)

                case .finished:
                    Logger.debug(message: "finished")
            }
        } receiveValue: { _ in
            self.fireStorageState = .done(String.blank)
        }
        .store(in: &cancellables)
    }

    func fetchDownloadUrlString(
        path: String,
        completion: @escaping (String) -> Void
    ) {
        fireStorageState = .loading

        FirebaseStorageManager.fetchDownloadUrlString(path: path)
            .sink { [weak self] completion in
                switch completion {
                    case let .failure(error):
                        self?.fireStorageState = .failed(error)

                    case .finished:
                        Logger.debug(message: "finished")
                }
            } receiveValue: { [weak self] state in
                self?.fireStorageState = .done(state)
                completion(state)
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
}
