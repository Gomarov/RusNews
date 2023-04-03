import Foundation

protocol DateConverterProtocol {
    func getShortDateAndTime(fromString string: String?) -> String?
}

final class DateConverter: DateConverterProtocol {

    private let locale = Locale(identifier: "ru")

    private lazy var dateFormatter = DateFormatter().with {
        $0.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        $0.locale = locale
    }

    private lazy var dateFormatterWithoutTimezone = DateFormatter().with {
        $0.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        $0.locale = locale
    }

    func date(from string: String?) -> Date? {
        guard var string = string else {
            return nil
        }
        
        if let range = string.range(of: "+")?.lowerBound {
            string = String(string.prefix(upTo: range))
        }

        return [dateFormatter.date(from: string),
                dateFormatterWithoutTimezone.date(from: string)]
            .compactMap { $0 }.first
    }

    func getTime(fromString string: String?) -> String? {
        return dateComponent(from: string, inFormat: "HH:mm")
    }

    func getShortDate(fromString string: String?) -> String? {
        return dateComponent(from: string, inFormat: "dd MMM")
    }

    func getShortDateAndTime(fromString string: String?) -> String? {
        guard
            let date = getShortDate(fromString: string),
            let time = getTime(fromString: string) else {
            return nil
        }
        return date + ", " + time
    }

    private func dateComponent(from sourceString: String?, inFormat format: String) -> String? {
        guard let date = date(from: sourceString) else {
            return nil
        }
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = locale
        return formatter.string(from: date)
    }
}
