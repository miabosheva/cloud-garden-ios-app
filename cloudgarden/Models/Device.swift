import Foundation
import SwiftUI

struct Device: Hashable, Codable, Identifiable, Equatable {
    var id = UUID()
    var deviceId: Int
    var code: String
    var macAddress: String
    var user: String?
    var plants: [Plant]
    //    var title: String
    
    enum CodingKeys: String, CodingKey {
        case code
        case macAddress
        case user
        case plants
        case deviceId = "id"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        code = try container.decode(String.self, forKey: .code)
        user = try container.decodeIfPresent(String.self, forKey: .user)
        plants = try container.decode([Plant].self, forKey: .plants)
        deviceId = try container.decode(Int.self, forKey: .deviceId)
        
        if let macAddressString = try? container.decode(String.self, forKey: .macAddress) {
            macAddress = macAddressString
        } else if let _ = try? container.decodeNil(forKey: .macAddress) {
            macAddress = ""
        } else {
            throw DecodingError.dataCorruptedError(forKey: .macAddress, in: container, debugDescription: "Invalid value for macAddress")
        }
        
        if let userString = try? container.decode(String.self, forKey: .user) {
            user = userString
        } else if let _ = try? container.decodeNil(forKey: .user) {
            user = ""
        } else {
            throw DecodingError.dataCorruptedError(forKey: .user, in: container, debugDescription: "Invalid value for user")
        }
        
        if let plantList = try? container.decode([Plant].self, forKey: .plants) {
            plants = plantList
        } else if let _ = try? container.decodeNil(forKey: .plants) {
            plants = []
        } else {
            throw DecodingError.dataCorruptedError(forKey: .plants, in: container, debugDescription: "Invalid value for plants")
        }
    }
}
