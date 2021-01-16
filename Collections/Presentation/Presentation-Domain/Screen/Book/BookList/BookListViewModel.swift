import RxSwift
import RxRelay

struct BookListCellData {
    let name: String
    let image: String?
    let price: Int?
    let purchaseDate: String?
}

final class BookListViewModel {
    private let usecase: BookListUsecase
    private let loadingSubject: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    private let resultSubject: BehaviorRelay<Result<BookListResponse, Error>?> = BehaviorRelay(value: nil)
    private let disposeBag: DisposeBag = DisposeBag()

    var loading: Observable<Bool> {
        loadingSubject.asObservable()
    }

    var result: Observable<Result<BookListResponse, Error>?> {
        resultSubject.asObservable()
    }

    var books: [BookListCellData] {
        map(book: usecase.books)
    }

    init(usecase: BookListUsecase) {
        self.usecase = usecase
        bindUsecase()
    }

    private func bindUsecase() {
        usecase.loading
            .bind(to: loadingSubject)
            .disposed(by: disposeBag)

        usecase.result
            .bind(to: resultSubject)
            .disposed(by: disposeBag)
    }

    func fetchBookList(isInitial: Bool) {
        usecase.fetchBookList(isInitial: isInitial)
    }

    private func map(book: [BookListResponse.Book]) -> [BookListCellData] {
        let books = book.map {
            BookListCellData(
                name: $0.name,
                image: $0.image,
                price: $0.price,
                purchaseDate: $0.purchaseDate
            )
        }
        return books
    }
}
