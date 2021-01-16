import UIKit

extension DateFormatter {

    private struct Constant {
        static let defaultFormat = "yyyy/MM/dd"
    }

    static func convertToYearAndMonth(_ date: Date?) -> String {
        guard let date = date else {
            return .blank
        }

        let formatter = DateFormatter()
        formatter.dateFormat = Constant.defaultFormat
        return formatter.string(from: date)
    }
}
