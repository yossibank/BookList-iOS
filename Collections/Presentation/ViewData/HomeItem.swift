import UIKit

struct HomeCellData {
    let title: String
    let image: UIImage?
    
    enum HomeItem: CaseIterable {
        typealias RawValue = HomeCellData

        case bookList
        case addBook
        case wishList

        var rawValue: RawValue {
            switch self {

            case .bookList:
                return HomeCellData(
                    title: Resources.Strings.Home.bookList,
                    image: Resources.Images.Home.bookList
                )

            case .addBook:
                return HomeCellData(
                    title: Resources.Strings.Home.addBook,
                    image: Resources.Images.Home.addBook
                )

            case .wishList:
                return HomeCellData(
                    title: Resources.Strings.Home.wishList,
                    image: Resources.Images.Home.wishList
                )
            }
        }

        var routes: Route {
            switch self {

            case .bookList:
                return .bookList

            case .addBook:
                return .addBook

            case .wishList:
                return .addBook
            }
        }
    }
}
