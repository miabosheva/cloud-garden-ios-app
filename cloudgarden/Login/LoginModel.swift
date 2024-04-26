//
//  LoginModel.swift
//  cloudgarden
//
//  Created by Mia Bosheva on 26.4.24.
//

import Foundation
import UIKit
import SwiftUI

class LoginModel: ObservableObject {
    
    private weak var window: UIWindow!
    
    init(window: UIWindow){
        self.window = window
    }
    
    func logIn(){
        let view = HomeNavigationView().navigationBarBackButtonHidden(true).navigationBarHidden(true)
        window.rootViewController = UIHostingController(rootView: view)
        print(window.rootViewController as Any)
    }
}
