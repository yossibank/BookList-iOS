import UIKit

extension UIDatePicker {

    private struct Constant {
        static let jpIdentifier = "ja_JP"
    }

    static let purchaseDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.date = Date()
        picker.datePickerMode = .date
        picker.timeZone = .current
        picker.locale = Locale(identifier: Constant.jpIdentifier)
        if #available(iOS 14, *) {
            picker.preferredDatePickerStyle = .wheels
        }
        return picker
    }()
}
