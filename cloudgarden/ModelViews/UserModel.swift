import Foundation
import SwiftUI
import UIKit
import Alamofire
import KeychainAccess

class UserModel: ObservableObject {
    // MARK: - Properties
    
    var modelData: ModelData = ModelData()
    private weak var window: UIWindow!
    var userResponse: UserResponse?
    var user: User?
    
    // MARK: - Init
    init(window: UIWindow) {
        self.window = window
    }
    
    // MARK: - Helpers
    func logOut(){
        self.user = nil
        let keychain = Keychain(service: "com.finki.cloudgarden")
        keychain["authInfo"] = nil
        
        let model = UserModel(window: self.window)
        let loginView = LoginView(userModel: model)
        self.window.rootViewController = UIHostingController(rootView: loginView)
        print(window.rootViewController as Any)
    }
    
    func getUser() -> User {
        if self.user == nil {
            print("somethings wrong with the user fetching")
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
    
    func register(username: String, password: String) -> Bool {
        // TODO: - Add user
        let parameters: [String: String] = [
            "username": username,
            "password": password
        ]
        
        AF
            .request(
                "https://cloudplant.azurewebsites.net/user",
                method: .post,
                parameters: parameters
            )
            .validate()
            .responseDecodable(of: UserResponse.self) { [weak self] dataResponse in
                guard let self = self else { return }
//                MBProgressHUD.hide(for: self.view, animated: true)
                switch dataResponse.result {
                case .success(let userResponse):
//                    let headers = dataResponse.response?.headers.dictionary ?? [:]
//                    self.handleSuccesfulLogin(for: userResponse.user, headers: headers)
                    self.userResponse = userResponse
                case .failure(let error):
                    print("Login failure error: \(error.localizedDescription).")
//                    loginButton.shake()
//                    showAlert()
                }
            }
        
        // should be authenticate
        return getUserByUsername(username: username)
    }
    
    func getUserByUsername(username: String) -> Bool {
        
        var sucessfulAuthentication: Bool = false
        
        AF
            .request(
                "https://cloudplant.azurewebsites.net/user/getuserbyusername",
                method: .get,
                parameters: ["username": username]
//                headers: HTTPHeaders(authInfo.headers)
            )
            .validate()
            .responseDecodable(of: UserResponse.self) { [weak self] dataResponse in
                guard let self = self else { return }
//                MBProgressHUD.hide(for: self.view, animated: true)
                switch dataResponse.result {
                case .success(let response):
                    let responseUser = User(username: response.username, password: response.password)
                    saveToKeychain(user: responseUser)
                    sucessfulAuthentication = true
                case .failure(let error):
                    // show error message on screen
                    print(error)
                }
            }
        
        return sucessfulAuthentication
    }
    
    func saveToKeychain(user: User){
        self.user = user
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(user) {
            let keychain = Keychain(service: "com.finki.cloudgarden")
            keychain[data: "authInfo"] = encoded
        }
    }
    
    func logIn(username: String, password: String){
        // should be authenticate
        if getUserByUsername(username: username) {
            setupViews(user: User(username: username, password: password))
        }
    }
    
    func setupViews(user: User) {
        let deviceAndPlantModel = DeviceAndPlantModel(user: user)
        let userModel = UserModel(window: self.window)
        
        let view = HomeNavigationView(userModel: userModel, deviceAndPlantModel: deviceAndPlantModel).navigationBarBackButtonHidden(true).navigationBarHidden(true)
        window.rootViewController = UIHostingController(rootView: view)
        print(window.rootViewController as Any)
    }
    
    func navigateToHomeFromOnboarding(deviceAndPlantModel: DeviceAndPlantModel){
        let deviceAndPlantModel = deviceAndPlantModel
        let userModel = UserModel(window: self.window)
        
        let view = HomeNavigationView(userModel: userModel, deviceAndPlantModel: deviceAndPlantModel).navigationBarBackButtonHidden(true).navigationBarHidden(true)
        window.rootViewController = UIHostingController(rootView: view)
        print(window.rootViewController as Any)
    }
}
