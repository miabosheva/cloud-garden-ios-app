import SwiftUI

struct PlantList: View {
    
    @State var goToAddEmptyPlant: Bool = false
    var model: DeviceAndPlantModel
    
    init(model: DeviceAndPlantModel){
        self.model = model
    }
    
    var body: some View {
        
        NavigationSplitView {
            ZStack {
                List{
                    
                    ForEach(model.getAllPlants()) { plant in
                        NavigationLink {
                            PlantDetail(plant: plant, model: model)
                        } label: {
                            PlantRow(plant: plant)
                        }
                    }
                    .onDelete(perform: deletePlant)
                }
                .animation(.default, value: model.plants)
                .navigationTitle("Plants")
                
                VStack {
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        Button {
                            self.goToAddEmptyPlant.toggle()
                        } label: {
                            RoundedRectangle(cornerRadius: 27)
                                .frame(maxWidth: 130, maxHeight: 50, alignment: .center)
                                .foregroundColor(Color("customDarkGreen"))
                                .overlay{
                                    Text("Add a Plant")
                                        .foregroundColor(.white)
                                }
                        }
                        .padding(.trailing, 16)
                        .padding(.bottom, 16)
                    }
                    
//                    NavigationLink(destination: AddEmptyPlant(model: model),
//                                   isActive: $goToAddEmptyPlant) {}
                }
            }
            .sheet(isPresented: $goToAddEmptyPlant) {
                AddEmptyPlant(model: model)
            }
        } detail: {
            Text("Plants")
        }
    }
    
    func deletePlant(at offsets: IndexSet) {
        for index in offsets {
            let deletedItemId = model.plants[index].title
            //            items.remove(at: index)
            print("Deleted item with ID:", deletedItemId)
        }
    }
}
