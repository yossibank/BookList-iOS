import RxSwift
import RxRelay

final class LoginViewModel {
    private let usecase: LoginUsecase!
    private let loadingRelay: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    private let resultRelay: BehaviorRelay<Result<LoginResponse, Error>?> = BehaviorRelay(value: nil)
    private let disposeBag: DisposeBag = DisposeBag()

    var loading: Observable<Bool> {
        loadingRelay.asObservable()
    }

    var result: Observable<Result<LoginResponse, Error>?> {
        resultRelay.asObservable()
    }

    init(usecase: LoginUsecase) {
        self.usecase = usecase
        bindUsecase()
    }

    private func bindUsecase() {
        usecase.loading
            .bind(to: loadingRelay)
            .disposed(by: disposeBag)

        usecase.result
            .bind(to: resultRelay)
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
