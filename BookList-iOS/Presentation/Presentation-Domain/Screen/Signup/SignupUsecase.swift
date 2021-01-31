import RxSwift
import RxRelay

final class SignupUsecase {
    private let loadingSubject: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    private let resultSubject: BehaviorRelay<Result<SignupResponse, Error>?> = BehaviorRelay(value: nil)
    private let disposeBag: DisposeBag = DisposeBag()

    var loading: Observable<Bool> {
        loadingSubject.asObservable()
    }

    var result: Observable<Result<SignupResponse, Error>?> {
        resultSubject.asObservable()
    }

    func signup(
        email: String,
        password: String
    ) {
        loadingSubject.accept(true)

        SignupRequest()
            .request(.init(
                        email: email,
                        password: password))
            .subscribe(
                onSuccess: { [weak self] response in
                    self?.loadingSubject.accept(false)
                    self?.resultSubject.accept(.success(response))
                    KeychainManager.shared.setToken(response.result.token)
                },
                onFailure: { [weak self] error in
                    self?.loadingSubject.accept(false)
                    self?.resultSubject.accept(.failure(error))
                })
            .disposed(by: disposeBag)
    }
}
