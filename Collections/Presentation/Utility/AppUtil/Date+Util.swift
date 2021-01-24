import Foundation

enum DateFormatType: String {
    case yearToDayOfWeek = "yyyy-MM-dd"
    case yearToDayOfWeekJapanese = "yyyy年MM月dd日"
}

extension Date {

    private struct Constant {
        static let jpIdentifier = "ja_JP"
    }

    var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: Constant.jpIdentifier)
        return dateFormatter
    }

    func toString(with dateFormatType: DateFormatType? = nil) -> String {
        let dateFormatter = self.dateFormatter
        dateFormatter.dateFormat = dateFormatType?.rawValue ?? dateFormatter.dateFormat
        return dateFormatter.string(from: self)
    }
}

extension Date {

    static func toConvertDate(_ string: String, with dateFormatType: DateFormatType? = nil) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormatType?.rawValue ?? dateFormatter.dateFormat
        return dateFormatter.date(from: string)
    }
}
