import Combine
import DomainKit
import Utility

final class WishListViewModel: ViewModel {

    var bookList: [BookBusinessModel] {
        BookFileManager.fetchData()
    }

    func updateBook(book: BookBusinessModel) {
        BookFileManager.setData(
            path: String(book.id),
            data: book.json
        )
    }
}
