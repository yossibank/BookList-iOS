import RxSwift
import RxRelay

final class AddBookUsecase {
    private let resultSubject: BehaviorRelay<Result<AddBookResponse, Error>?> = BehaviorRelay(value: nil)
    private let disposeBag: DisposeBag = DisposeBag()

    var result: Observable<Result<AddBookResponse, Error>?> {
        resultSubject.asObservable()
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
                    self?.resultSubject.accept(.success(response))
                },
                onFailure: { [weak self] error in
                    self?.resultSubject.accept(.failure(error))
                })
            .disposed(by: disposeBag)
    }
}
