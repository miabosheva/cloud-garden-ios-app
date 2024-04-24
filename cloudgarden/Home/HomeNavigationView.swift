import SwiftUI

struct HomeNavigationView: View {
    
    @State private var modelData = ModelData()
    @State private var selection = 0
    
    var body: some View {
        TabView(selection: $selection) {
            
            DeviceList().environment(modelData)
                .tabItem {
                    Text("")
                    Image(selection == 0 ? "list-active" : "list")
                    
                }
                .tag(0)
            
            PlantList().environment(modelData)
                .tabItem {
                    Text("")
                    Image(selection == 1 ? "flower-active" : "flower")
                }
                .tag(1)
            
            ProfileView().environment(modelData)
                .tabItem {
                    Text("")
                    Image(selection == 2 ? "user-active" : "user")
                }
                .tag(2)
        }
    }
}

#Preview {
    HomeNavigationView()
}
