import Combine
import DomainKit
import Utility

final class AccountViewModel: ViewModel {
    typealias State = LoadingState<NoEntity, APPError>

    @Published private(set) var state: State = .standby

    private let usecase: LogoutUsecase

    private var cancellables: Set<AnyCancellable> = []

    init(usecase: LogoutUsecase = Domain.Usecase.Account.Logout()) {
        self.usecase = usecase
    }
}

// MARK: - internal methods

extension AccountViewModel {

    func logout() {
        state = .loading

        usecase
            .logout()
            .sink { [weak self] completion in
                switch completion {
                    case let .failure(error):
                        Logger.debug(message: error.localizedDescription)
                        self?.state = .failed(.init(error: error))

                    case .finished:
                        Logger.debug(message: "finished")
                }
            } receiveValue: { [weak self] state in
                self?.state = .done(state)
            }
            .store(in: &cancellables)
    }
}
