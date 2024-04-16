import SwiftUI

struct PlantRow: View {
    
    var plant: Plant
    
    var plantHealth = 0.6
    var imageName = "defaultPlant"
    var plantName = "Plant Name"
    var deviceName = "Device Name"
    var plantHealthBarDescription = "In good health"
    
    
    var body: some View {
        
        HStack {
            
            Image(imageName).resizable().frame(width: 80, height: 80).clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/).padding(.trailing, 16)
            
            VStack (alignment: .leading) {
                
                Text(plant.title).font(.title2)
                
                Text("\(plant.deviceId)").font(.subheadline).foregroundStyle(.secondary)
                
                ProgressView(value: plantHealth, label: { Text(plantHealthBarDescription).font(.subheadline)})
                    .frame(maxWidth: UIScreen.main.bounds.width - 180)
                    .tint(Color("customGreen"))
            }
        }
        
    }
}

#Preview {
    let plants = ModelData().plants
    
    return Group{
        PlantRow(plant: plants[0])
        PlantRow(plant: plants[1])
    }
    
}
