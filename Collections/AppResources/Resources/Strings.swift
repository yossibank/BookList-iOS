struct StringResources {

    private typealias Internal = R.string

    struct App {
        static var email: String { Internal.localizable.mail_address() }
        static var password: String { Internal.localizable.password() }
        static var title: String { Internal.localizable.title() }
        static var price: String { Internal.localizable.price() }
        static var purchaseDate: String { Internal.localizable.purchase_date() }
        static var failedSignup: String { Internal.localizable.failed_signup() + "\n" + Internal.localizable.maybe_already_email() }
        static var failedLogin: String { Internal.localizable.failed_login() + "\n" + Internal.localizable.please_check_again_contents() }
        static var failedAddBook: String { Internal.localizable.failed_add_book() }
        static var successAddBook: String { Internal.localizable.success_add_book() }
    }

    struct Home {
        static var bookList: String { Internal.localizable.book_list() }
        static var addBook: String { Internal.localizable.add_book() }
        static var wishList: String { Internal.localizable.wish_list_book() }
    }

    struct Navigation {
        static var done: String { Internal.localizable.done() }
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

        static var emailEmpty: String { Internal.localizable.not_filled(Resources.Strings.App.email) }
        static var passwordEmpty: String { Internal.localizable.not_filled(Resources.Strings.App.password) }
        static var titleEmpty: String { Internal.localizable.not_filled(Resources.Strings.App.title) }
        static var priceEmpty: String { Internal.localizable.not_filled(Resources.Strings.App.price) }
        static var purchaseDateEmpty: String { Internal.localizable.not_filled(Resources.Strings.App.purchaseDate) }
        static var invalidEmailFormat: String { Internal.localizable.not_correct_format_email() }
        static var notFilledPassword: String { Internal.localizable.not_length_password(minimumLength) }
        static var notMatchingPassword: String { Internal.localizable.not_matching_password() }
        static var onlyNumber: String { Internal.localizable.only_input_number() }
    }
}
