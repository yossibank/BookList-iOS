import XCTest
@testable import BookManager

class BookValidationTests: XCTestCase {

    func testInputValidationForEmpty() {

        XCTContext.runActivity(named: "book title") { _ in

            XCTAssertFalse(TitleValidator.validate(.blank).isValid)

            XCTContext.runActivity(named: "error message") { _ in
                XCTAssertEqual(
                    TitleValidator.validate(.blank).errorDescription,
                    Resources.Strings.Validator.titleEmpty
                )
            }
        }

        XCTContext.runActivity(named: "book purchase date") { _ in

            XCTAssertFalse(PurchaseDateValidator.validate(.blank).isValid)

            XCTContext.runActivity(named: "error message") { _ in
                XCTAssertEqual(
                    PurchaseDateValidator.validate(.blank).errorDescription,
                    Resources.Strings.Validator.purchaseDateEmpty
                )
            }
        }

        XCTContext.runActivity(named: "book price") { _ in

            XCTAssertFalse(NumberValidator.validate(.blank).isValid)

            XCTContext.runActivity(named: "error message") { _ in
                XCTAssertEqual(
                    NumberValidator.validate(.blank).errorDescription,
                    Resources.Strings.Validator.priceEmpty
                )
            }
        }
    }

    func testBookTitleValidationForLength() {

        XCTContext.runActivity(named: "valid book title") { _ in
            let validTitle = "valid title"
            XCTAssertTrue(TitleValidator.validate(validTitle).isValid)
        }

        XCTContext.runActivity(named: "invalid book title") { _ in
            let lengthTitle = "this book title is more than 30 characters count"
            XCTAssertFalse(TitleValidator.validate(lengthTitle).isValid)

            XCTAssertEqual(
                TitleValidator.validate(lengthTitle).errorDescription,
                Resources.Strings.Validator.notLognerTitleText
            )
        }
    }

    func testBookPriceValidationForOnlyNumber() {

        XCTContext.runActivity(named: "valid book price") { _ in
            let validPrice = "1000"
            XCTAssertTrue(NumberValidator.validate(validPrice).isValid)
        }

        XCTContext.runActivity(named: "invalid book price") { _ in
            let invalidPrice = "1000aa"
            XCTAssertFalse(NumberValidator.validate(invalidPrice).isValid)

            XCTContext.runActivity(named: "error message") { _ in
                XCTAssertEqual(
                    NumberValidator.validate(invalidPrice).errorDescription,
                    Resources.Strings.Validator.onlyNumber
                )
            }
        }
    }
}
