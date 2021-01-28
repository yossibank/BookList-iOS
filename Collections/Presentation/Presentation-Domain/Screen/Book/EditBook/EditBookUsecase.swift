import Foundation
import RxSwift
import RxRelay

final class EditBookUsecase {
    private let bookId: Int
    private let resultSubject: BehaviorRelay<Result<EditBookResponse, Error>?> = BehaviorRelay(value: nil)
    private let disposeBag: DisposeBag = DisposeBag()

    var result: Observable<Result<EditBookResponse, Error>?> {
        resultSubject.asObservable()
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
        URLCache.shared.removeAllCachedResponses()

        EditBookRequest(id: bookId)
            .request(.init(
                        name: name,
                        image: image,
                        price: price,
                        purchaseDate: purchaseDate))
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
