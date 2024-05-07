import SwiftUI

struct PlantRow: View {
    
    // MARK: - Properties
    private var plant: Plant
    private var plantHealth = 0.6
    private var imageName = "defaultPlant"
    private var plantName = "Plant Name"
    private var deviceName = "Device Name"
    private var plantHealthBarDescription = "In good health"
    
    // MARK: - Init
    init(plant: Plant){
        self.plant = plant
    }
    
    var body: some View {
        
        HStack {
            
            Image(imageName)
                .resizable()
                .frame(width: 80, height: 80)
                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                .padding(.trailing, 10)

            
            VStack (alignment: .leading) {
                
                Text(plant.title)
                    .font(.title2)
                
                Text("Plant Type: \(plant.plantTypeName)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                ProgressView(value: plantHealth, label: { Text(plantHealthBarDescription)
                    .font(.subheadline)})
                    .frame(maxWidth: UIScreen.main.bounds.width - 180)
                    .tint(Color("customGreen"))
            }
            .padding(.vertical, 8)
        }
        
    }
}
