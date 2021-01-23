import UIKit
import RxSwift
import RxRelay

struct EditBookViewData {
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

    func getBookData() -> (name: String, image: String, price: String, purchaseDate: String) {
        var book: (name: String, image: String, price: String, purchaseDate: String) = ("", "", "", "")

        book.name = bookData.name
        if let imageUrl = bookData.image {
            book.image = imageUrl
        }
        if let price = bookData.price {
            book.price = price.description
        }
        if let purchaseDate = bookData.purchaseDate {
            if let dateFormat = Date.toConvertDate(purchaseDate, with: .yearToDayOfWeek) {
                book.purchaseDate = dateFormat.toString(with: .yearToDayOfWeekJapanese)
            }
        }

        return book
    }
}
