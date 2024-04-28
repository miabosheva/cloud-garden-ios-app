import Foundation
import SwiftUI

struct Device: Hashable, Codable, Identifiable, Equatable {
    var id = UUID()
    var deviceId: Int
    var code: String
    var macAddress: String
    var user: String
    var plants: [Plant]
//    var title: String
    
    enum CodingKeys: String, CodingKey {
        case deviceId = "Id"
        case code, macAddress, user, plants
    }
    
    init(code: String){
        self.deviceId = -1
        self.macAddress = ""
        self.code = code
        self.user = ""
        self.plants = []
    }
}
