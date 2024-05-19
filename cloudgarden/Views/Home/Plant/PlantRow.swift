import SwiftUI

struct PlantRow: View {
    
    // MARK: - Properties
    @State private var plant: Plant
    private var model: DeviceAndPlantModel
    private var imageName = "defaultPlant"
    @State private var plantHealthPlacehoder = 0.0
    @State private var plantHealthBarDescription = ""
    @State private var barColor = Color(.customRed)
    
    // MARK: - Init
    init(plant: Plant, model: DeviceAndPlantModel){
        self.plant = plant
        self.model = model
    }
    
    var body: some View {
        HStack {
            
            RoundedRectangle(cornerRadius: 15)
                .frame(width: 75, height: 75)
                .foregroundColor(.customOffWhite)
                .overlay {
                    Text("🌱")
                        .font(.system(size:33))
                }
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
                            plantHealthBarDescription = "Bad Health"
                        }
                        if plantHealth > 0.3 && plantHealth <= 0.6 {
                            barColor = .customLemon
                            plantHealthBarDescription = "Moderate Health"
                        }
                        if plantHealth > 0.6 {
                            barColor = .customLimeGreen
                            plantHealthBarDescription = "Good Health"
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
        .presentationBackground(.regularMaterial)
    }
}
