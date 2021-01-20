import UIKit

struct ImageResources {
    
    private typealias Internal = R.image
    
    struct Account {
        static var checkInBox: UIImage? { Internal.check_In_Box() }
        static var checkOffBox: UIImage? { Internal.check_Off_Box() }
    }

    struct Home {
        static var bookList: UIImage? { Internal.book_list() }
        static var addBook: UIImage? { Internal.add_book() }
        static var wishList: UIImage? { Internal.wish_list() }
    }

    struct General {
        static var noImage: UIImage? { Internal.no_Image() }
        static var logout: UIImage? { Internal.logout() }
    }
}
