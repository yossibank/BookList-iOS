import RxSwift
import RxRelay

final class SignupViewModel {
    private let usecase: SignupUsecase!
    private let loadingSubject: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    private let resultSubject: BehaviorRelay<Result<SignupResponse, Error>?> = BehaviorRelay(value: nil)
    private let disposeBag: DisposeBag = DisposeBag()

    var loading: Observable<Bool> {
        loadingSubject.asObservable()
    }

    var result: Observable<Result<SignupResponse, Error>?> {
        resultSubject.asObservable()
    }

    init(usecase: SignupUsecase) {
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

    func signup(
        email: String,
        password: String
    ) {
        usecase.signup(
            email: email,
            password: password
        )
    }
}
