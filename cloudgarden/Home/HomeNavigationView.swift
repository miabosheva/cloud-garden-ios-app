import SwiftUI

struct HomeNavigationView: View {
    
    @State private var modelData = ModelData()
    
    var body: some View {
        TabView {
            
            DeviceList().environment(modelData)
                .tabItem {
                    Label("Devices", systemImage: "desktopcomputer")
                }
            
            PlantList().environment(modelData)
                .tabItem {
                    Label("Plants", systemImage: "leaf.fill")
                }
            
            ProfileView().environment(modelData)
                .tabItem {
                    Label("Profile", systemImage: "desktopcomputer")
                }
        }
    }
}

#Preview {
    HomeNavigationView()
}
