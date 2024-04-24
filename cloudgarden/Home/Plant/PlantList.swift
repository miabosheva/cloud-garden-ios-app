import SwiftUI

struct PlantList: View {
    
    @Environment(ModelData.self) var modelData
    
    @State var goToAddPlant: Bool = false
    
    var body: some View {
        NavigationSplitView {
            ZStack {
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
                
                
                // TODO: - Add a button + View for adding a Plant
                VStack {
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        Button {
                            self.goToAddPlant.toggle()
                        } label: {
                            RoundedRectangle(cornerRadius: 27)
                                .frame(maxWidth: 50, maxHeight: 50, alignment: .center)
                                .foregroundColor(Color("customDarkGreen"))
                                .overlay{
                                    Text("+")
                                        .font(.title)
                                        .foregroundColor(.white)
                                }
                        }
                        .padding(.trailing, 32)
                        .padding(.bottom, 16)
                    }
                    
                    NavigationLink(destination: AddEditPlant(), isActive: $goToAddPlant) {}
                }
            }
        } detail: {
            Text("Plants")
        }
    }
}

#Preview {
    PlantList().environment(ModelData())
}
