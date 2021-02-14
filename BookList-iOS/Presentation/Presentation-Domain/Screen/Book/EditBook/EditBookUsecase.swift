import RxSwift
import RxRelay

final class EditBookUsecase {
    private let bookId: Int
    private let resultRelay: BehaviorRelay<Result<EditBookResponse, Error>?> = BehaviorRelay(value: nil)
    private let disposeBag: DisposeBag = DisposeBag()

    var result: Observable<Result<EditBookResponse, Error>?> {
        resultRelay.asObservable()
    }

    init(bookId: Int) {
        self.bookId = bookId
    }

    func editBook(
        name: String,
        image: String?,
        price: Int?,
        purchaseDate: String?
    ) {
        EditBookRequest(id: bookId)
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
