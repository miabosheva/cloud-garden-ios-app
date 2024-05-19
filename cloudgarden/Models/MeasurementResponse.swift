import Foundation

struct MeasurementResponse: Codable, Identifiable, Hashable {
    var id = UUID()
    var measurementId: Int
    var temperatureMeasurement: Int
    var humidityMeasurement: Int
    var soilMeasurement: Int
    var lightIntensity: Int
    var plantId: Int
    var dateRaw: String
    // Date string from backend comes in a different format
    var date: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let formattedDateRaw = String(dateRaw.prefix(dateRaw.count - 8))
        return dateFormatter.date(from: formattedDateRaw)
    }
    
    enum CodingKeys: String, CodingKey {
        case measurementId = "id"
        case temperatureMeasurement
        case humidityMeasurement
        case soilMeasurement
        case lightIntensity
        case plantId
        case dateRaw = "date"
    }
}
