import RxSwift
import RxRelay

final class HomeViewModel {
    private let usecase: HomeUsecase!
    private let resultRelay: BehaviorRelay<Result<LogoutResponse, Error>?> = BehaviorRelay(value: nil)
    private let disposeBag: DisposeBag = DisposeBag()

    var result: Observable<Result<LogoutResponse, Error>?> {
        resultRelay.asObservable()
    }

    init(usecase: HomeUsecase) {
        self.usecase = usecase
        bindUsecase()
    }

    private func bindUsecase() {
        usecase.result
            .bind(to: resultRelay)
            .disposed(by: disposeBag)
    }

    func logout() {
        usecase.logout()
    }
}
