import Foundation

struct MeasurementResponse: Codable, Identifiable, Hashable {
    var id = UUID()
    var measurementId: Int
    var temperatureMeasurement: Int
    var humidityMeasurement: Int
    var soilMeasurement: Int
    var plantId: Int
    
    enum CodingKeys: String, CodingKey {
        case measurementId = "id"
        case temperatureMeasurement
        case humidityMeasurement
        case soilMeasurement
        case plantId
    }
}
