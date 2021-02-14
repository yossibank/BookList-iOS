import RxSwift
import RxRelay

final class AddBookUsecase {
    private let resultRelay: BehaviorRelay<Result<AddBookResponse, Error>?> = BehaviorRelay(value: nil)
    private let disposeBag: DisposeBag = DisposeBag()

    var result: Observable<Result<AddBookResponse, Error>?> {
        resultRelay.asObservable()
    }

    func addBook(
        name: String,
        image: String?,
        price: Int?,
        purchaseDate: String?
    ) {
        AddBookRequest()
            .request(
                .init(
                    name: name,
                    image: image,
                    price: price,
                    purchaseDate: purchaseDate
                )
            )
            .subscribe(
                onSuccess: { [weak self] response in
                    self?.resultRelay.accept(.success(response))
                },
                onFailure: { [weak self] error in
                    self?.resultRelay.accept(.failure(error))
                })
            .disposed(by: disposeBag)
    }
}
