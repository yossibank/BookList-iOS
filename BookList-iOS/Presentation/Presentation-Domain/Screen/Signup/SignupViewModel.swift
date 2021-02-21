import RxSwift
import RxRelay

final class SignupViewModel {
    private let usecase: SignupUsecase!
    private let loadingRelay: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    private let resultRelay: BehaviorRelay<Result<SignupResponse, Error>?> = BehaviorRelay(value: nil)
    private let disposeBag: DisposeBag = DisposeBag()

    var loading: Observable<Bool> {
        loadingRelay.asObservable()
    }

    var result: Observable<Result<SignupResponse, Error>?> {
        resultRelay.asObservable()
    }

    init(usecase: SignupUsecase) {
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

    func signup(
        email: String,
        password: String
    ) {
        usecase.signup(
            email: email,
            password: password
        )
    }

    func createUserForFirebase(
        email: String,
        password: String,
        user: SignupResponse.User
    ) {
        FirebaseAuthManager.shared.createUserWithFirestore(
            email: email,
            password: password,
            user: user
        )
    }
}
