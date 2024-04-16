//
//  HomeView.swift
//  cloudgarden
//
//  Created by Mia Bosheva on 16.4.24.
//

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
        }
    }
}

#Preview {
    HomeNavigationView()
}
