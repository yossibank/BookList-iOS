import RxSwift
import RxRelay

final class LoginUsecase {
    private let loadingSubject: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    private let resultSubject: BehaviorRelay<Result<LoginResponse, Error>?> = BehaviorRelay(value: nil)
    private let disposeBag: DisposeBag = DisposeBag()

    var loading: Observable<Bool> {
        loadingSubject.asObservable()
    }

    var result: Observable<Result<LoginResponse, Error>?> {
        resultSubject.asObservable()
    }

    func login(email: String, password: String) {

        loadingSubject.accept(true)

        LoginRequest().request(.init(email: email, password: password))
            .subscribe(onSuccess: { response in
                self.loadingSubject.accept(false)
                self.resultSubject.accept(.success(response))
            }, onFailure: { error in
                self.loadingSubject.accept(false)
                self.resultSubject.accept(.failure(error))
            })
            .disposed(by: disposeBag)
    }
}
