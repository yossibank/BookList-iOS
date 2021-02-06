import XCTest
@testable import BookList_iOS

class AccountValidationTests: XCTestCase {

    func testInputValidationForEmpty() {

        XCTContext.runActivity(named: "email") { _ in

            XCTAssertFalse(EmailValidator.validate(.blank).isValid)

            XCTContext.runActivity(named: "error message") { _ in
                XCTAssertEqual(
                    EmailValidator.validate(.blank).errorDescription,
                    Resources.Strings.Validator.emailEmpty
                )
            }
        }

        XCTContext.runActivity(named: "password") { _ in

            XCTAssertFalse(PasswordValidator.validate(.blank).isValid)
            
            XCTContext.runActivity(named: "error message") { _ in
                XCTAssertEqual(
                    PasswordValidator.validate(.blank).errorDescription,
                    Resources.Strings.Validator.passwordEmpty
                )
            }
        }
    }

    func testEmailValidationForRegex() {

        XCTContext.runActivity(named: "valid email") { _ in
            let validEmail = "test@test.com"
            XCTAssertTrue(EmailValidator.validate(validEmail).isValid)
        }

        XCTContext.runActivity(named: "invalid email") { _ in
            let invalidEmail = "test@test"
            XCTAssertFalse(EmailValidator.validate(invalidEmail).isValid)

            XCTContext.runActivity(named: "error message") { _ in
                XCTAssertEqual(
                    EmailValidator.validate(invalidEmail).errorDescription,
                    Resources.Strings.Validator.invalidEmailFormat
                )
            }
        }
    }
    
    func testPasswordValidationForLength() {
        
        XCTContext.runActivity(named: "valid password") { _ in
            let validPassword = "hogehoge"
            XCTAssertTrue(PasswordValidator.validate(validPassword).isValid)
        }
        
        XCTContext.runActivity(named: "invalid password") { _ in
            let invalidPassword = "foo"
            XCTAssertFalse(PasswordValidator.validate(invalidPassword).isValid)
            
            XCTContext.runActivity(named: "error message") { _ in
                XCTAssertEqual(
                    PasswordValidator.validate(invalidPassword).errorDescription,
                    Resources.Strings.Validator.notFilledPassword
                )
            }
        }
    }
}
