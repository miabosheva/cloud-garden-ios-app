import Foundation
import SwiftUI

struct User: Hashable, Codable, Identifiable, Equatable {
    var id = UUID()
    var username: String
    var password: String
    
    enum CodingKeys: String, CodingKey {
        case username, password
    }
}
