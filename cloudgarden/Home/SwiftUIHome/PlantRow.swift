//
//  PlantRow.swift
//  cloudgarden
//
//  Created by Mia Bosheva on 8.4.24.
//

import SwiftUI

struct PlantRow: View {
    
    var plant: PlantDTO
    
    @State private var plantHealth = 0.6
    @State private var imageName = "defaultPlant"
    @State private var plantName = "Plant Name"
    @State private var deviceName = "Device Name"
    @State private var plantHealthBarDescription = "In good health"
    
//    init(plant: PlantDTO) {
//        self.plant = plant
////        self.plantHealth = plantHealth
////        self.imageName = imageName
//        self.plantName = plant.title
//        self.deviceName = "Device ID: \(plant.id)"
////        self.plantHealthBarDescription = plantHealthBarDescription
//    }
    
    var body: some View {
        
        HStack{
        
            RoundedRectangle(cornerRadius: 15)
                .frame(width: UIScreen.main.bounds.width - 30, height: 125)
                .foregroundColor(Color("customGrey"))
                .overlay{
                    
                    HStack{
                        
                        HStack {
                            Image(imageName).resizable().frame(width: 80, height: 80).clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/).padding(.leading, 20).padding(.trailing, 10)
                        }
                        
                        VStack {
                            
                            HStack {
                                
                                Text(plantName).font(.title2)
                                Spacer()
                            }
                                
                            HStack {
                                
                                Text(deviceName).font(.subheadline).foregroundStyle(.secondary)
                                Spacer()
                            }
                            
                            
                            HStack {
                                
                                ProgressView(value: plantHealth, label: { Text(plantHealthBarDescription).font(.subheadline).padding(.top, 5)})
                                    .frame(maxWidth: UIScreen.main.bounds.width - 170)
                                .tint(Color("customGreen"))
                                Spacer()
                            }
                        }
                    }
                }
        }
        
    }
}

#Preview {
    let plants = ModelData().plants
    
    return Group{
        PlantRow(plant: plants[0])
        PlantRow(plant: plants[1])
//        PlantRow()
    }
    
}
