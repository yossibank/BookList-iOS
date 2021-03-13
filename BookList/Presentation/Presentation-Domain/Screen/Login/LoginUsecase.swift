import RxSwift
import RxRelay

final class LoginUsecase {
    private let loadingRelay: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    private let resultRelay: BehaviorRelay<Result<LoginResponse, Error>?> = BehaviorRelay(value: nil)
    private let disposeBag: DisposeBag = DisposeBag()

    var loading: Observable<Bool> {
        loadingRelay.asObservable()
    }

    var result: Observable<Result<LoginResponse, Error>?> {
        resultRelay.asObservable()
    }

    func login(
        email: String,
        password: String
    ) {
        loadingRelay.accept(true)

        LoginRequest()
            .request(.init(
                        email: email,
                        password: password))
            .subscribe(
                onSuccess: { [weak self] response in
                    KeychainManager.shared.setToken(response.result.token)
                    self?.loadingRelay.accept(false)
                    self?.resultRelay.accept(.success(response))
                    self?.signInForFirebase(
                        email: email,
                        password: password
                    )
                },
                onFailure: { [weak self] error in
                    self?.loadingRelay.accept(false)
                    self?.resultRelay.accept(.failure(error))
                })
            .disposed(by: disposeBag)
    }

    private func signInForFirebase(
        email: String,
        password: String
    ) {
        FirebaseAuthManager.shared.signIn(
            email: email,
            password: password
        )
    }
}
