import Foundation

enum DateFormatType: String {
    case yearToDayOfWeek = "yyyy-MM-dd"
    case yearToDayOfWeekJapanese = "yyyy年MM月dd日"
    case timeStamp = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
    case hourToMinitue = "HH:mm"
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

    func toConvertString(
        with dateFormatType: DateFormatType? = nil
    ) -> String {
        let dateFormatter = self.dateFormatter
        dateFormatter.dateFormat = dateFormatType?.rawValue ?? dateFormatter.dateFormat
        return dateFormatter.string(from: self)
    }
}

extension Date {

    static func toConvertDate(
        _ string: String,
        with dateFormatType: DateFormatType? = nil
    ) -> Date? {
        let dateFormatter = Self().dateFormatter
        dateFormatter.dateFormat = dateFormatType?.rawValue ?? dateFormatter.dateFormat
        return dateFormatter.date(from: string)
    }

    static func convertBookPurchaseDate(dateString: String?) -> String {
        if let dateString = dateString {
            if let date = toConvertDate(dateString, with: .yearToDayOfWeek) {
                return date.toConvertString(with: .yearToDayOfWeekJapanese)
            }
        }

        return .blank
    }
}
