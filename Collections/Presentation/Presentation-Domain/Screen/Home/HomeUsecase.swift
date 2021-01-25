import RxSwift
import RxRelay

final class HomeUsecase {
    private let resultSubject: BehaviorRelay<Result<LogoutResponse, Error>?> = BehaviorRelay(value: nil)
    private let disposeBag: DisposeBag = DisposeBag()

    var result: Observable<Result<LogoutResponse, Error>?> {
        resultSubject.asObservable()
    }

    func logout() {
        LogoutRequest().request(.init())
            .subscribe(onSuccess: { response in
                self.resultSubject.accept(.success(response))
                KeychainManager.shared.removeToken()
            }, onFailure: { error in
                self.resultSubject.accept(.failure(error))
            })
            .disposed(by: disposeBag)
    }
}
