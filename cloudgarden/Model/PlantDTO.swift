//
//  Plant.swift
//  cloudgarden
//
//  Created by Mia Bosheva on 8.4.24.
//

import Foundation
import SwiftUI


struct PlantDTO: Decodable {
    var id: Int //Id
    var title: String //Title
//    var lastWatering: Date //LastWatering
//    var nextWatering: Date //NextWatering
    
    // MARK: - DTO elements
    
    var plantTypeId: Int //PlantTypeId
    var deviceId: Int //DeviceId
    
    enum CodingKeys: String, CodingKey {
            case id = "Id"
            case title = "Title"
//            case lastWatering = "LastWatering"
//            case nextWatering = "NextWatering"
            case plantTypeId = "PlantTypeId"
            case deviceId = "DeviceId"
    }
    
//    var plantType: PlantType //PlantType
//    
//    struct PlantType: Hashable, Codable{
//        var plantTypeName: String //PlantTypeName
//        var thresholdValue1: Float //ThresholdValue1
//        var thresholdValue2: Float //ThresholdValue2
//        var thresholdValue3: Float //ThresholdValue3
//        var thresholdValue4: Float //ThresholdValue4
//    }
    
    
}
