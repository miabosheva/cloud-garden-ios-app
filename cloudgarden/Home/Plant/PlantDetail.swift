//
//  PlantDetail.swift
//  cloudgarden
//
//  Created by Mia Bosheva on 16.4.24.
//

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
