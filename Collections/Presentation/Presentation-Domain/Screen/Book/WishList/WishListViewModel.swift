final class WishListViewModel {

    var books: [BookViewData] {
        BookFileManagement.shared.fetchData()
    }

    func getBookId(index: Int) -> Int? {
        books.any(at: index)?.id
    }
}
