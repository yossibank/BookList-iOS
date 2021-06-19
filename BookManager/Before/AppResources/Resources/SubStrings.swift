struct StringResources {

    private typealias Internal = R.string

    struct Navigation {
        static var done: String { Internal.localizable.done() }
        static var add: String { Internal.localizable.add() }
        static var cancel: String { Internal.localizable.cancel() }
        static var startTalk: String { Internal.localizable.start_talk() }
    }

    struct App {
        static var nickName: String { Internal.localizable.nick_name() }
        static var email: String { Internal.localizable.mail_address() }
        static var password: String { Internal.localizable.password() }
        static var logout: String { Internal.localizable.logout() }
        static var title: String { Internal.localizable.title() }
        static var price: String { Internal.localizable.price() }
        static var purchaseDate: String { Internal.localizable.purchase_date() }
        static var home: String { Internal.localizable.home() }
        static var bookList: String { Internal.localizable.book_list() }
        static var addBook: String { Internal.localizable.add_book() }
        static var editBook: String { Internal.localizable.edit_book() }
        static var wishList: String { Internal.localizable.wish_list_book() }
        static var chat: String { Internal.localizable.chat() }
        static var talkList: String { Internal.localizable.talk_list() }
        static var selectUser: String { Internal.localizable.select_user() }
        static var yen: String { Internal.localizable.yen() }
        static var taxText: String { Internal.localizable.plus() + Internal.localizable.tax() }
    }

    struct Alert {
        static var failedSignup: String { Internal.localizable.failed_signup() + "\n" + Internal.localizable.maybe_already_email() }
        static var failedLogin: String { Internal.localizable.failed_login() + "\n" + Internal.localizable.please_check_again_contents() }
        static var failedLogout: String { Internal.localizable.failed_logout() }
        static var failedBookList: String { Internal.localizable.failed_book_list() }
        static var failedAddBook: String { Internal.localizable.failed_add_book() }
        static var failedEditBook: String { Internal.localizable.failed_edit_book() }
        static var successAddBook: String { Internal.localizable.success_add_book() }
        static var successEditBook: String { Internal.localizable.success_edit_book() }
        static var didYouLogout: String { Internal.localizable.did_you_logout() }
    }

    struct General {
        static var yes: String { Internal.localizable.yes() }
        static var no: String { Internal.localizable.no() }
        static var success: String { Internal.localizable.success() }
        static var failure: String { Internal.localizable.failure() }
        static var close: String { Internal.localizable.close() }
        static var error: String { Internal.localizable.error() }
    }

    struct Validator {
        private static let minimumLength = "6"
        private static let maxLength = "30"

        static var nameEmpty: String { Internal.localizable.not_filled(Resources.Strings.App.nickName) }
        static var emailEmpty: String { Internal.localizable.not_filled(Resources.Strings.App.email) }
        static var passwordEmpty: String { Internal.localizable.not_filled(Resources.Strings.App.password) }
        static var titleEmpty: String { Internal.localizable.not_filled(Resources.Strings.App.title) }
        static var priceEmpty: String { Internal.localizable.not_filled(Resources.Strings.App.price) }
        static var purchaseDateEmpty: String { Internal.localizable.not_filled(Resources.Strings.App.purchaseDate) }
        static var invalidEmailFormat: String { Internal.localizable.not_correct_format_email() }
        static var notFilledPassword: String { Internal.localizable.not_length_password(minimumLength) }
        static var notMatchingPassword: String { Internal.localizable.not_matching_password() }
        static var notLognerTitleText: String { Internal.localizable.not_longer_title_text(maxLength) }
        static var onlyNumber: String { Internal.localizable.only_input_number() }
    }

    struct API {
        static let apiBaseUrl = "http://54.250.239.8"
        static let authorization = "Authorization"
    }

    struct Firebase {
        static let metaDataType = "image/jpeg"
        static let userIconPath = "user_icon"
    }
}