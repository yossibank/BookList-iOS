import Combine
import DomainKit
import Utility

final class WishListViewModel: ViewModel {

    var books: [BookViewData] {
        BookFileManager.fetchData()
    }

    func updateBook(book: BookViewData) {
        BookFileManager.setData(
            path: String(book.id),
            data: book.json
        )
    }
}
