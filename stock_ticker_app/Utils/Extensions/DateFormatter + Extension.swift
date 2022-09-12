
import Foundation

struct XTDateFormatterStruct {
    
    static var localeIdentifier: String {
            return "en_US"
    }
    
    static var shortDateFormat: String {
            return "dd MMMM yyyy"
        }
    
    static var fullDateTimeFormat: String {
            return "EEE, dd MMM yyyy HH:mm a"
    }
    
    static var shortDateFormatWithTime : String {
        return "dd MMM yyyy h : mm a"
    }
    
    static let formatter: DateFormatter = {
        return getDateFormatter()
    }()
    
    static func getDateFormatterEnglishOnly(dateFormat: String? = nil) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale(identifier: localeIdentifier)
        formatter.dateFormat = dateFormat
        return formatter
    }
    
    static func getDateFormatter(dateFormat: String? = nil) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: localeIdentifier)
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = dateFormat
        return formatter
    }
    
    static func xt_defaultDateTimeFormatter() -> DateFormatter {
        return getDateFormatter(dateFormat: "dd-MMM-yyyy | h:mm a") /* 01-Dec-2020 4:03 pm */
    }
    
    static func xt_fullDateFormatter() -> DateFormatter {
        return getDateFormatter(dateFormat: "yyyy-MM-dd'T'HH:mm:ssZZZ")
    }
}



