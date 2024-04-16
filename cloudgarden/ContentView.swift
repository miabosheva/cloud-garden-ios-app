//
//  ContentView.swift
//  cloudgarden
//
//  Created by Mia Bosheva on 16.4.24.
//

import SwiftUI

struct ContentView: View {
    @State private var isLoggedIn = false
    @State private var modelData = ModelData()
    
    var body: some View {
        if isLoggedIn {
            PlantList().environment(modelData)
        } else {
            LoginView(isLoggedIn: $isLoggedIn)
        }
    }
}
