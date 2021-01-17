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
    private let resultSubject: BehaviorRelay<Result<EditBookResponse, Error>?> = BehaviorRelay(value: nil)
    private let disposeBag: DisposeBag = DisposeBag()
    private var bookData: EditBookViewData

    var result: Observable<Result<EditBookResponse, Error>?> {
        resultSubject.asObservable()
    }

    init(bookData: EditBookViewData) {
        self.bookData = bookData
    }

    func editBook(name: String, image: String?, price: Int?, purchaseDate: String?) {
        EditBookRequest(id: bookData.id)
            .request(
                .init(
                    name: bookData.name,
                    image: bookData.image,
                    price: bookData.price,
                    purchaseDate: bookData.purchaseDate
                )
            )
            .subscribe(onSuccess: { response in
                self.resultSubject.accept(.success(response))
                self.bookData = self.map(book: response.result)
            }, onFailure: { error in
                self.resultSubject.accept(.failure(error))
            })
            .disposed(by: disposeBag)
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

extension EditBookViewModel {

    var getBookData: EditBookViewData {
        return bookData
    }
}
