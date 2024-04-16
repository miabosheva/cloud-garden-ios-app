import SwiftUI

struct PlantList: View {
    
    @Environment(ModelData.self) var modelData
    
    var body: some View {
        NavigationSplitView {
            List{
                ForEach(modelData.plants) { plant in
                    NavigationLink {
                        PlantDetail(plant: plant)
                    } label: {
                        PlantRow(plant: plant)
                    }
                }
            }
            .animation(.default, value: modelData.plants)
            .navigationTitle("Plants")
        } detail: {
            Text("Plants")
        }
    }
}

#Preview {
    PlantList().environment(ModelData())
}
