import Foundation

// MARK: - DateFormatters
extension DateFormatter {
    static var userFriendlyDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MM YYYY "
        return dateFormatter
    }()
    
    static var userFriendlyTimeFormatter: DateFormatter = {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        return timeFormatter
    }()
}
