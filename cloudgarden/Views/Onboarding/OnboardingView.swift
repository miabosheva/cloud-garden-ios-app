//
//  OnboardingView.swift
//  cloudgarden
//
//  Created by Mia Bosheva on 26.4.24.
//

import SwiftUI

enum OnboardingTab {
    case step1
    case step2
    case step3
    case step4
}

struct OnboardingView: View {
    @State var selection: OnboardingTab = .step1
    
    var userModel: UserModel
    var deviceAndPlantModel: DeviceAndPlantModel
    
    init(userModel: UserModel, deviceAndPlantModel: DeviceAndPlantModel){
        self.userModel = userModel
        self.deviceAndPlantModel = deviceAndPlantModel
    }
    
    var body: some View {
        TabView (selection: $selection) {
            WelcomeView(tab: $selection)
                .tag(OnboardingTab.step1)
            ConnectToWifiView(tab: $selection)
                .tag(OnboardingTab.step2)
            ClickOnTheLinkView(tab: $selection)
                .tag(OnboardingTab.step3)
            EnterIDView(tab: $selection)
                .environmentObject(userModel)
                .environmentObject(deviceAndPlantModel)
                .tag(OnboardingTab.step4)
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .indexViewStyle(.page(backgroundDisplayMode: .always))
    }
}
