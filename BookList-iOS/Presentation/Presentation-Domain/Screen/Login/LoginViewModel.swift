import RxSwift
import RxRelay

final class LoginViewModel {
    private let usecase: LoginUsecase!
    private let loadingSubject: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    private let resultSubject: BehaviorRelay<Result<LoginResponse, Error>?> = BehaviorRelay(value: nil)
    private let disposeBag: DisposeBag = DisposeBag()

    var loading: Observable<Bool> {
        loadingSubject.asObservable()
    }

    var result: Observable<Result<LoginResponse, Error>?> {
        resultSubject.asObservable()
    }

    init(usecase: LoginUsecase) {
        self.usecase = usecase
        bindUsecase()
    }

    private func bindUsecase() {
        usecase.loading
            .bind(to: loadingSubject)
            .disposed(by: disposeBag)

        usecase.result
            .bind(to: resultSubject)
            .disposed(by: disposeBag)
    }

    func login(
        email: String,
        password: String
    ) {
        usecase.login(
            email: email,
            password: password
        )
    }
}
