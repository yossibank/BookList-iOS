import UIKit

final class WishListViewModel {
    
    var books: [BookViewData] {
        BookFileManagement.shared.fetchData()
    }
}
