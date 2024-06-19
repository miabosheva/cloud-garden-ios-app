import SwiftUI
import ProgressHUD
import NotificationBannerSwift

struct DeviceDetail: View {
    
    // MARK: - Properties
    @State private var newName: String = ""
    @State private var goToAddPlant: Bool = false
    @State private var goToHome: Bool = false
    private let device: Device
    @ObservedObject private var model: DeviceAndPlantModel
    @State private var plants: [Plant] = []
    
    // MARK: - Init
    init(device: Device, model: DeviceAndPlantModel){
        self.device = device
        self.model = model
    }
    
    var body: some View {
        
        NavigationView {
            
            VStack (alignment: .center){
                
                Text(device.title)
                    .font(.title)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .padding(.top, 8)
                
                Text("Device ID: \(device.deviceId)")
                    .font(.footnote)
                
                
                HStack {
                    Text("Device Name")
                        .font(.headline)
                        .fontWeight(.semibold)
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                
                RoundedRectangle(cornerRadius: 15)
                    .frame(maxWidth: .infinity, maxHeight: 44, alignment: .center)
                    .foregroundColor(.white)
                    .shadow(radius: 2, x: 0, y: 0)
                    .overlay{
                        TextField("Device Name", text: $newName).padding()
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 8)
                
                Button(action: saveName) {
                    RoundedRectangle(cornerRadius: 27)
                        .frame(maxWidth: .infinity, maxHeight: 44, alignment: .center)
                        .foregroundColor(Color("customLimeGreen"))
                        .overlay{
                            Text("Save Name")
                                .foregroundColor(.white)
                                .fontWeight(.semibold)
                        }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
                
                Spacer()
                
                List {
                    if self.plants.count > 0 {
                        ForEach(plants) { plant in
                            PlantRow(plant: plant, model: model)
                        }
                        .onDelete(perform: deletePlant)
                    } else {
                        EmptyLottieView(keyword: "plants")
                    }
                }
                .onAppear {
                    Task {
                        await getAllPlants()
                    }
                }
                .refreshable {
                    Task {
                        await getAllPlants()
                    }
                }
                
                Button{
                    goToAddPlant.toggle()
                } label: {
                    
                    RoundedRectangle(cornerRadius: 27)
                        .frame(maxWidth: .infinity, maxHeight: 44, alignment: .center)
                        .foregroundColor(Color("customDarkGreen"))
                        .overlay{
                            Text("Add a Plant to Device")
                                .foregroundColor(.white)
                        }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                
            }
        }
        .accentColor(.customDarkGreen)
        .sheet(isPresented: $goToAddPlant, content: {
            NavigationStack {
                AddPlant(model: model, device: device)
            }
        })
    }
    
    // MARK: - Helper Methods
    func getAllPlants() async {
        do {
            try await model.getAllPlantsByUsername(username: self.model.user.username)
            self.plants = model.plants.filter{$0.deviceId == self.device.deviceId}
        } catch {
            print("Error loading plants: \(error)")
            DispatchQueue.main.async {
                let banner = NotificationBanner(title: "Error occured. Refresh the page.", style: .warning)
                banner.show()
            }
        }
    }
    
    func saveName() {
        if newName != "" {
            ProgressHUD.animate()
            Task {
                do {
                    try await model.addUserToDevice(code: self.device.code, title: newName)
                } catch {
                    DispatchQueue.main.async {
                        let banner = NotificationBanner(title: "Error updating name.", style: .danger)
                        banner.show()
                        ProgressHUD.dismiss()
                        newName = ""
                    }
                    return
                }
            }
            let banner = NotificationBanner(title: "Successfully changed \(device.title)'s name to \(newName).", style: .success)
            banner.show()
            ProgressHUD.dismiss()
        } else {
            let banner = NotificationBanner(title: "Please enter a valid name.", style: .warning)
            banner.show()
        }
        newName = ""
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
                    try await getAllPlants()
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
