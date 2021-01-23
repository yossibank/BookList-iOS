import Foundation
import RxSwift
import RxRelay

struct BookListCellData: Codable {
    var id: Int
    var name: String
    var image: String?
    var price: Int?
    var purchaseDate: String?
    var isFavorite: Bool?

    var json: Data? {
        try? JSONEncoder().encode(self)
    }

    init(
        id: Int,
        name: String,
        image: String?,
        price: Int?,
        purchaseDate: String?
    ) {
        self.id = id
        self.name = name
        self.image = image
        self.price = price
        self.purchaseDate = purchaseDate
    }

    init?(json: Data) {
        if let newValue = try? JSONDecoder().decode(BookListCellData.self, from: json) {
            self = newValue
        } else {
            return nil
        }
    }
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

    func getBookId(index: Int) -> Int? {
        books.any(at: index)?.id
    }

    func resetBookData() {
        usecase.books = []
    }

    func fetchBookList(isInitial: Bool) {
        usecase.fetchBookList(isInitial: isInitial)
    }

    func saveFavorite(book: BookListCellData) {
        let fileManager = FileManager.default
        guard let url = try? fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent(String(book.id)) else { return }
        
        do {
            try book.json?.write(to: url)
            print("okok")
        } catch {
            print(error)
        }
    }

    func getFavoritePath() {
        let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            let contentUrls = try FileManager.default.contentsOfDirectory(at: documentDirectoryURL, includingPropertiesForKeys: nil)
            let files = contentUrls.map{$0.lastPathComponent}
            files.forEach { file in
                guard let url = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(file) else { return }

                 do {
                     let jsonData = try Data(contentsOf: url)
                     let readChocolates = BookListCellData(json: jsonData)
                    print("content", readChocolates)
                } catch let error {
                     print(error)
                }
            }
        } catch {
            print(error)
        }
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
