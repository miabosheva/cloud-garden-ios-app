import Foundation
import SwiftUI
import UIKit

class UserModel: ObservableObject {
    // MARK: - Properties
    
    var modelData: ModelData = ModelData()
    private weak var window: UIWindow!
    var authInfo: AuthInfo?
    var userResponse: UserResponse?
    var user: User?
    
    // MARK: - Init
    init(window: UIWindow) {
        self.window = window
    }
    
    // MARK: - Helpers
    func logOut(){
        let model = UserModel(window: self.window)
        let loginView = LoginView(userModel: model)
        self.window.rootViewController = UIHostingController(rootView: loginView)
        print(window.rootViewController as Any)
    }
    
    func getUser() -> User {
        if self.user == nil {
            self.user = modelData.users[0]
        }
        return self.user!
    }
    
    func changePasswordForUser(user: User, newPassword: String) {
        return
    }
    
    func getDeviceCount() -> Int{
        return -1
    }
    
    func getPlantCount() -> Int{
        return -1
    }
    
    func register(username: String, password: String) {
        
    }
    
    func logIn(){
        // TODO: - API to login
        // if login success:
        setupViews()
    }
    
    func setupViews() {
//        guard let authInfo = authInfo else {
//            return
//        }
        let deviceAndPlantModel = DeviceAndPlantModel(authInfo: nil)
        let userModel = UserModel(window: self.window)
        
        let view = HomeNavigationView(userModel: userModel, deviceAndPlantModel: deviceAndPlantModel).navigationBarBackButtonHidden(true).navigationBarHidden(true)
        window.rootViewController = UIHostingController(rootView: view)
        print(window.rootViewController as Any)
    }
    
    func navigateToHomeFromOnboarding(deviceAndPlantModel: DeviceAndPlantModel){
//        guard let authInfo = authInfo else {
//            return
//        }
        let deviceAndPlantModel = deviceAndPlantModel
        let userModel = UserModel(window: self.window)
        
        let view = HomeNavigationView(userModel: userModel, deviceAndPlantModel: deviceAndPlantModel).navigationBarBackButtonHidden(true).navigationBarHidden(true)
        window.rootViewController = UIHostingController(rootView: view)
        print(window.rootViewController as Any)
    }
}
