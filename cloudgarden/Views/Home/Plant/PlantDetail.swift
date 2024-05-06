import SwiftUI

struct PlantDetail: View {
    
    // MARK: - Properties
    private let plant: Plant
    private let imageName: String = "defaultPlant"
    private let status: String = "well watered"
    @State private var date = Date()
    private var model: DeviceAndPlantModel
    
    // MARK: - Init
    init(plant: Plant, model: DeviceAndPlantModel) {
        self.plant = plant
        self.model = model
    }
    
    var body: some View {
        ZStack {
            Colors.white.ignoresSafeArea()
            
            ZStack {
                TabView {
                    AddWateringEntry()
                    AnalyticsView()
                }
                .background(Colors.white)
                .tabViewStyle(.page)
                
                
                VStack {
                    ZStack {
                        Rectangle()
                            .fill(Colors.appBackground)
                            .frame(maxWidth: .infinity)
                            .frame(height: 200)
                        
                        HStack(alignment: .center) {
                            
                            Image(imageName)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: 80)
                                .padding(.horizontal, 16)
                                .clipShape(Circle())
                            
                            VStack(alignment: .leading) {
                                Text(plant.title)
                                    .font(.title)
                                    .bold()
                                    .foregroundColor(.white)
                                
                                Text("Device: Some Device")
                                    .foregroundColor(Colors.white)
                                    .bold()
                                    .font(.caption)
                                
                                Text("Last Watering: X days ago")
                                    .foregroundColor(Colors.white)
                                    .font(.caption)
                            }
                            .padding(.trailing, 16)
                            
                            Spacer()
                        }
                        .padding(.top, 30)
                        .padding(.bottom, 16)
                        .offset(y: 30)
                    }
                    .ignoresSafeArea()
                    Spacer()
                }
            }
        }
    }
}
