import Foundation
import SwiftUI

struct Device: Hashable, Codable, Identifiable, Equatable {
    var id = UUID()
    var title: String
    var numberOfPlants: Int
    
    enum CodingKeys: String, CodingKey {
        case title, numberOfPlants
    }
}
