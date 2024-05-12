import Foundation
import SwiftUI

struct Plant: Hashable, Codable, Identifiable, Equatable {
    var id = UUID()
    var plantId: Int
    var title: String
    var lastWatering: String
    var nextWatering: String
    var plantTypeId: Int
    var deviceId: Int
    var plantTypeName: String
    var thresholdValue1: Int
    var thresholdValue2: Int
    var thresholdValue3: Int
    var thresholdValue4: Int
    var plantHealth: Double? = 0
    
    enum CodingKeys: String, CodingKey {
        case plantId = "id"
        case title
        case lastWatering
        case nextWatering
        case plantTypeId
        case deviceId
        case plantTypeName
        case thresholdValue1
        case thresholdValue2
        case thresholdValue3
        case thresholdValue4
    }
}
