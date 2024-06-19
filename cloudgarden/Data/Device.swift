import Foundation
import SwiftUI

struct Device: Hashable, Codable, Identifiable, Equatable {
    var id = UUID()
    var deviceId: Int
    var code: String
//    var macAddress: String
    var user: String?
    var plants: [Plant]? = []
    var title: String
    
    enum CodingKeys: String, CodingKey {
        case code
//        case macAddress
        case user
        case deviceId = "id"
        case title = "name"
    }
}
