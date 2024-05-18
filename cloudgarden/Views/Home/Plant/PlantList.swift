import SwiftUI
import NotificationBannerSwift

struct PlantList: View {
    
    // MARK: - Properties
    @StateObject private var refreshManager = RefreshManager()
    @State private var plants: [Plant] = []
    @State private var goToAddEmptyPlant: Bool = false
    private var model: DeviceAndPlantModel
    
    
    // MARK: - Init
    init(model: DeviceAndPlantModel){
        self.model = model
    }
    
    var body: some View {
        
        NavigationSplitView {
            ZStack {
                List{
                    if plants.count > 0 {
                        ForEach(plants) { plant in
                            NavigationLink {
                                PlantDetail(plant: plant, model: model).navigationBarBackButtonHidden()
                            } label: {
                                PlantRow(plant: plant, model: model)
                            }
                        }
                        .onDelete(perform: deletePlant)
                    } else {
                        EmptyLottieView(keyword: "plants")
                    }
                }
                .onAppear {
                    Task {
                        await getAllPlants()
                        if model.devices.count == 0 {
                            model.devices = try await model.getDevicesByUsernameRequest()
                        }
                    }
                }
                .refreshable {
                    Task {
                        await getAllPlants()
                    }
                }
                .onReceive(refreshManager.$shouldRefresh) { shouldRefresh in
                    if shouldRefresh {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            refreshManager.shouldRefresh = false
                        }
                    }
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
                }
            }
            .sheet(isPresented: $goToAddEmptyPlant) {
                AddEmptyPlant(goToAddEmptyPlant: $goToAddEmptyPlant).environmentObject(model)
            }
        } detail: {
            Text("Plants")
        }
        .accentColor(.customGreen) 
    }
    
    // MARK: - Helper Methods
    func getAllPlants() async {
        do {
            let plants = try await model.getAllPlantsByUsername(username: self.model.user.username)
            self.plants = plants
        } catch {
            print("Error loading plants: \(error)")
            DispatchQueue.main.async {
                let banner = NotificationBanner(title: "Error occured. Refresh the page.", style: .warning)
                banner.show()
            }
        }
    }
    
    func deletePlant(at offsets: IndexSet) {
        for index in offsets {
            let deletedItemId = plants[index].plantId
            Task {
                do {
                    // TODO: - implement function
                    let result = try await model.deletePlant(plantId: deletedItemId)
                    if result {
                        DispatchQueue.main.async {
                            let banner = NotificationBanner(title: "Sucessfuly deleted Plant \(plants[index].title)", style: .success)
                            banner.show()
                        }
                    }
                } catch {
                    DispatchQueue.main.async {
                        let banner = NotificationBanner(title: "Failed to delete plant", style: .danger)
                        banner.show()
                    }
                }
            }
            print("Deleted plant with ID:", deletedItemId)
        }
    }
}
