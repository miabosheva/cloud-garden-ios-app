//
//  ContentView.swift
//  cloudgarden
//
//  Created by Mia Bosheva on 16.4.24.
//

import SwiftUI

struct ContentView: View {
    @State private var isLoggedIn = false
    
    var body: some View {
        if isLoggedIn {
            HomeNavigationView()
        } else {
            LoginView(isLoggedIn: $isLoggedIn)
        }
    }
}
