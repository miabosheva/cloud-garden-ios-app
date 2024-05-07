import Foundation

struct PlantType: Codable, Identifiable, Hashable {
    var id = UUID()
    var plantTypeId: Int
    var plantTypeName: String
    var thresholdValue1: Int
    var thresholdValue2: Int
    var thresholdValue3: Int
    var thresholdValue4: Int
    
    enum CodingKeys: String, CodingKey {
        case plantTypeId = "id"
        case plantTypeName
        case thresholdValue1
        case thresholdValue2
        case thresholdValue3
        case thresholdValue4
    }
}
