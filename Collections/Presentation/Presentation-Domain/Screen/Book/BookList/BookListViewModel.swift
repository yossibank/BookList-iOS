import RxSwift
import RxRelay

struct BookListCellData {
    let id: Int
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

    func getBookId(index: Int) -> Int? {
        books.any(at: index)?.id
    }

    private func map(book: [BookListResponse.Book]) -> [BookListCellData] {
        let books = book.map { book in
            BookListCellData(
                id: book.id,
                name: book.name,
                image: book.image,
                price: book.price,
                purchaseDate: book.purchaseDate
            )
        }
        return books
    }
}
