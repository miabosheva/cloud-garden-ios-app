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
    
    init(userModel: UserModel){
        self.userModel = userModel
    }
    
    var body: some View {
        TabView (selection: $selection) {
            WelcomeView(tab: $selection)
                .tag(OnboardingTab.step1)
            ConnectToWifiView(tab: $selection)
                .tag(OnboardingTab.step2)
            ClickOnTheLinkView(tab: $selection)
                .tag(OnboardingTab.step3)
            EnterIDView(tab: selection, userModel: userModel)
                .tag(OnboardingTab.step4)
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        //no animation
        .indexViewStyle(.page(backgroundDisplayMode: .always))
    }
}
