import Combine
import DomainKit
import Utility

final class WishListViewModel: ViewModel {

    var books: [BookViewData] {
        BookFileManager.shared.fetchData()
    }

    func updateBook(book: BookViewData) {
        BookFileManager.shared.setData(
            path: String(book.id),
            data: book.json
        )
    }
}
