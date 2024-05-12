import SwiftUI

struct PlantRow: View {
    
    // MARK: - Properties
    private var plant: Plant
    private var model: DeviceAndPlantModel
    private var imageName = "defaultPlant"
    @State private var plantHealthPlacehoder = 0.0
    @State private var plantHealthBarDescription = "In good health"
    @State private var barColor = Color(.customRed)
    
    // MARK: - Init
    init(plant: Plant, model: DeviceAndPlantModel){
        self.plant = plant
        self.model = model
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
                    .fontWeight(.semibold)
                    .font(.title2)
                
                Text("Plant Type: \(plant.plantTypeName)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 4)
                
                ProgressView(value: plantHealthPlacehoder, label: { Text(plantHealthBarDescription)
                    .font(.subheadline)})
                .frame(maxWidth: UIScreen.main.bounds.width - 180)
                .tint(barColor)
            }
            .padding(.vertical, 8)
        }
        .onAppear {
            Task {
                do {
                    let plantHealth = try await model.calculatePlantHealth(plantId: self.plant.plantId)
                    
                    DispatchQueue.main.async {
                        self.plantHealthPlacehoder = plantHealth
                        if plantHealth <= 0.3 {
                            barColor = .customRed
                            plantHealthBarDescription = "In bad health"
                        }
                        if plantHealth > 0.3 && plantHealth <= 0.6 {
                            barColor = .customLemon
                            plantHealthBarDescription = "In moderate health"
                        }
                        if plantHealth > 0.6 {
                            barColor = .customGreen
                            plantHealthBarDescription = "In good health"
                        }
                    }
                } catch {
                    DispatchQueue.main.async {
                        barColor = .customRed
                        plantHealthPlacehoder = 0.0
                        plantHealthBarDescription = "Plant Health Not Available"
                    }
                }
            }
        }
    }
}
