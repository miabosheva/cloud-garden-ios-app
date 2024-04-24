import SwiftUI

struct PlantDetail: View {
    
    let plant: Plant
    
    var body: some View {
        Text(plant.title)
    }
}

#Preview {
    let plants = ModelData().plants
    
    return Group {
        PlantDetail(plant: plants[1])
    }
    
}
