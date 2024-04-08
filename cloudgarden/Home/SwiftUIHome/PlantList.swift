//
//  PlantList.swift
//  cloudgarden
//
//  Created by Mia Bosheva on 8.4.24.
//

import SwiftUI

struct PlantList: View {
    @Environment(ModelData.self) var modelData
    
    var plants: [PlantDTO] {
        modelData.plants
    }
    
    var body: some View {
        NavigationSplitView {
            List{
                ForEach(plants) { plant in
                    NavigationLink {
//                        PlantDetail(plant: plant)
                    } label: {
                        PlantRow(plant: plant)
                    }
                }
            }
            .animation(.default, value: plants)
            .navigationTitle("Plants")
        } detail: {
            Text("Select a Landmark")
        }
    }
}

#Preview {
    PlantList()
}
