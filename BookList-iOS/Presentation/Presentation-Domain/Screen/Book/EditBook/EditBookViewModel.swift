import RxSwift
import RxRelay

final class EditBookViewModel {
    private let usecase: EditBookUsecase!
    private let resultRelay: BehaviorRelay<Result<EditBookResponse, Error>?> = BehaviorRelay(value: nil)
    private let disposeBag: DisposeBag = DisposeBag()

    var result: Observable<Result<EditBookResponse, Error>?> {
        resultRelay.asObservable()
    }

    init(usecase: EditBookUsecase) {
        self.usecase = usecase
        bindUsecase()
    }

    private func bindUsecase() {
        usecase.result
            .bind(to: resultRelay)
            .disposed(by: disposeBag)
    }

    func updateFavoriteBook(book: EditBookResponse.Book, isFavorite: Bool) {
        let book = map(book: book, isFavorite: isFavorite)

        BookFileManager.shared.setData(
            path: String(book.id),
            data: book.json
        )
    }

    private func map(
        book: EditBookResponse.Book,
        isFavorite: Bool
    ) -> BookViewData {
        BookViewData(
            id: book.id,
            name: book.name,
            image: book.image,
            price: book.price,
            purchaseDate: book.purchaseDate,
            isFavorite: isFavorite
        )
    }

    func editBook(
        name: String,
        image: String?,
        price: Int?,
        purchaseDate: String?
    ) {
        usecase.editBook(
            name: name,
            image: image,
            price: price,
            purchaseDate: purchaseDate
        )
    }
}
