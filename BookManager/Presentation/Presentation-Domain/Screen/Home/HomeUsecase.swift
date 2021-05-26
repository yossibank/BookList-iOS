import RxSwift
import RxRelay

final class HomeUsecase {
    private let resultRelay: BehaviorRelay<Result<LogoutResponse, Error>?> = BehaviorRelay(value: nil)
    private let disposeBag: DisposeBag = DisposeBag()

    var result: Observable<Result<LogoutResponse, Error>?> {
        resultRelay.asObservable()
    }

    func logout() {
        LogoutRequest()
            .request(.init())
            .subscribe(
                onSuccess: { [weak self] response in
                    KeychainManager.shared.removeToken()
                    self?.resultRelay.accept(.success(response))
                    self?.logoutForFirebase()
                },
                onFailure: { [weak self] error in
                    self?.resultRelay.accept(.failure(error))
                })
            .disposed(by: disposeBag)
    }

    private func logoutForFirebase() {
        FirebaseAuthManager.shared.logout()
    }
}
