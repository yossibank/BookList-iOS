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
        static var chat: UIImage? { Internal.chat() }
    }

    struct BookList {
        static var favorite: UIImage? { Internal.favorite() }
        static var nonFavorite: UIImage? { Internal.no_favorite() }
    }

    struct Chat {
        static var addChatUser: UIImage? { Internal.add_chat_user() }
    }

    struct General {
        static var noImage: UIImage? { Internal.no_Image() }
        static var logout: UIImage? { Internal.logout() }
    }
}
