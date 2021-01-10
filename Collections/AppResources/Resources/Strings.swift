struct StringResources {

    private typealias Internal = R.string
    
    struct Validator {
        private static let minimumLength = "6"

        static var emailEmpty: String { Internal.localizable.not_input_email() }
        static var passwordEmpty: String { Internal.localizable.not_input_password() }
        static var invalidEmailFormat: String { Internal.localizable.not_correct_format_email() }
        static var notFilledPassword: String { Internal.localizable.not_length_password(minimumLength) }
        static var notMatchingPassword: String { Internal.localizable.not_matching_password() }
    }
}
