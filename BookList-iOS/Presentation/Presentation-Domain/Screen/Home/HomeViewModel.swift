import RxSwift
import RxRelay

final class HomeViewModel {
    private let usecase: HomeUsecase!
    private let resultSubject: BehaviorRelay<Result<LogoutResponse, Error>?> = BehaviorRelay(value: nil)
    private let disposeBag: DisposeBag = DisposeBag()

    var result: Observable<Result<LogoutResponse, Error>?> {
        resultSubject.asObservable()
    }

    init(usecase: HomeUsecase) {
        self.usecase = usecase
        bindUsecase()
    }

    private func bindUsecase() {
        usecase.result
            .bind(to: resultSubject)
            .disposed(by: disposeBag)
    }

    func logout() {
        usecase.logout()
    }
}
