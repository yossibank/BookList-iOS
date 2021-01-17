import UIKit
import RxSwift
import RxRelay

struct EditBookViewData {
    let id: Int
    let name: String
    let image: String?
    let price: Int?
    let purchaseDate: String?
}

final class EditBookViewModel {
    private let usecase: EditBookUsecase
    private let bookData: EditBookViewData
    private let resultSubject: BehaviorRelay<Result<EditBookResponse, Error>?> = BehaviorRelay(value: nil)
    private let disposeBag: DisposeBag = DisposeBag()

    var result: Observable<Result<EditBookResponse, Error>?> {
        resultSubject.asObservable()
    }

    var getBook: EditBookViewData {
        bookData
    }

    init(usecase: EditBookUsecase, bookData: EditBookViewData) {
        self.usecase = usecase
        self.bookData = bookData
        bindUsecase()
    }

    private func bindUsecase() {
        usecase.result
            .bind(to: resultSubject)
            .disposed(by: disposeBag)
    }

    func editBook(name: String, image: String?, price: Int?, purchaseDate: String?) {
        usecase.editBook(
            name: name,
            image: image,
            price: price,
            purchaseDate: purchaseDate
        )
    }

    private func map(book: EditBookResponse.Book) -> EditBookViewData {
        return EditBookViewData(
            id: book.id,
            name: book.name,
            image: book.image,
            price: book.price,
            purchaseDate: book.purchaseDate
        )
    }
}
