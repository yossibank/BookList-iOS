import Foundation
import OSLog

public struct Logger {
    private static var osLog = OSLog.default

    public static func info(
        message: String,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        self.doLog(
            message: message,
            osLog: self.osLog,
            logType: .info,
            file: file,
            function: function,
            line: line
        )
    }

    public static func debug(
        message: String,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        self.doLog(
            message: message,
            osLog: self.osLog,
            logType: .debug,
            file: file,
            function: function,
            line: line
        )
    }

    public static func error(
        message: String,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        self.doLog(
            message: message,
            osLog: self.osLog,
            logType: .error,
            file: file,
            function: function,
            line: line
        )
    }

    public static func fault(
        message: String,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        self.doLog(
            message: message,
            osLog: self.osLog,
            logType: .fault,
            file: file,
            function: function,
            line: line
        )
    }
}

extension Logger {
    private static func doLog(
        message: String,
        osLog: OSLog,
        logType: OSLogType = .default,
        file: String,
        function: String,
        line: Int
    ) {
        #if DEBUG
        os_log(
            "❗️[%@] %@ %@ L:%d %@",
            log: osLog,
            type: logType,
            String(describing: logType),
            file.split(separator: "/").last! as CVarArg,
            function,
            line, message
        )
        #endif
    }
}

extension OSLogType: CustomStringConvertible {
    public var description: String {
        switch self {
        case .info:
            return "INFO"

        case .debug:
            return "DEBUG"

        case .error:
            return "ERROR"

        case .fault:
            return "FAULT"

        default:
            return "DEFAULT"
        }
    }
}
