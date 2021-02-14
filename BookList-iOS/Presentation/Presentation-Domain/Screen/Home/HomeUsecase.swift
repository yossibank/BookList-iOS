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
                    self?.resultRelay.accept(.success(response))
                    KeychainManager.shared.removeToken()
                },
                onFailure: { [weak self] error in
                    self?.resultRelay.accept(.failure(error))
                })
            .disposed(by: disposeBag)
    }
}
