import RxSwift
import RxRelay

final class AddBookViewModel {
    private let usecase: AddBookUsecase!
    private let resultRelay: BehaviorRelay<Result<AddBookResponse, Error>?> = BehaviorRelay(value: nil)
    private let disposeBag: DisposeBag = DisposeBag()

    var result: Observable<Result<AddBookResponse, Error>?> {
        resultRelay.asObservable()
    }

    init(usecase: AddBookUsecase) {
        self.usecase = usecase
        bindUsecase()
    }

    private func bindUsecase() {
        usecase.result
            .bind(to: resultRelay)
            .disposed(by: disposeBag)
    }

    func addBook(
        name: String,
        image: String?,
        price: Int?,
        purchaseDate: String?
    ) {
        usecase.addBook(
            name: name,
            image: image,
            price: price,
            purchaseDate: purchaseDate
        )
    }
}
