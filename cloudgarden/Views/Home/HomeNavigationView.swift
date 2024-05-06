import SwiftUI

struct HomeNavigationView: View {
    
    // MARK: - Properites
    @State private var selection = 0
    @StateObject var userModel: UserModel
    @StateObject var deviceAndPlantModel: DeviceAndPlantModel
    
    var body: some View {
        TabView(selection: $selection) {
            
            DeviceList(model: deviceAndPlantModel)
                .tabItem {
                    Text("")
                    Image(selection == 0 ? "list-active" : "list")
                }
                .tag(0)
            
            PlantList(model: deviceAndPlantModel)
                .tabItem {
                    Text("")
                    Image(selection == 1 ? "flower-active" : "flower")
                }
                .tag(1)
            
            ProfileView(model: userModel)
                .tabItem {
                    Text("")
                    Image(selection == 2 ? "user-active" : "user")
                }
                .tag(2)
        }
    }
}
