import UIKit

struct HomeViewData {
    let title: String
    let image: UIImage?

    enum HomeItem: CaseIterable {
        typealias RawValue = HomeViewData

//        case bookList
        case addBook
        case wishList
        case chatSelect

        var rawValue: RawValue {

            switch self {

//            case .bookList:
//                return HomeViewData(
//                    title: Resources.Strings.App.bookList,
//                    image: Resources.Images.Home.bookList
//                )

            case .addBook:
                return HomeViewData(
                    title: Resources.Strings.App.addBook,
                    image: Resources.Images.Home.addBook
                )

            case .wishList:
                return HomeViewData(
                    title: Resources.Strings.App.wishList,
                    image: Resources.Images.Home.wishList
                )

            case .chatSelect:
                return HomeViewData(
                    title: Resources.Strings.App.chat,
                    image: Resources.Images.Home.chat
                )
            }
        }

        var routes: Route {

            switch self {

//            case .bookList:
//                return .bookList

            case .addBook:
                return .addBook

            case .wishList:
                return .wishList

            case .chatSelect:
                return .chatSelect
            }
        }
    }
}
