import Foundation
import SwiftUI
import UIKit
import Alamofire
import KeychainAccess

enum AuthentiactionError: Error {
    case serializationError
    case invalidResponse
    case httpError(statusCode: Int)
    case noData
    case jsonParsingError
}

class UserModel: ObservableObject {
    
    // MARK: - Properties
    var modelData: ModelData = ModelData()
    private weak var window: UIWindow!
    var user: User?
    
    // MARK: - Init
    init(window: UIWindow) {
        self.window = window
    }
    
    // MARK: - Helper methods
    func logOut() {
        // Take the user to login, delete all login info
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
    
    func getDeviceCount() -> Int {
        return -1
    }
    
    func getPlantCount() -> Int {
        return -1
    }
    
    func register(username: String, password: String) async throws -> Bool {
        let url = URL(string: "https://cloudplant.azurewebsites.net/authentication/signup")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["username": username, "password": password]
        
        guard let bodyData = try? JSONSerialization.data(withJSONObject: body) else {
            throw AuthentiactionError.serializationError
        }
        
        request.httpBody = bodyData
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw AuthentiactionError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw AuthentiactionError.httpError(statusCode: httpResponse.statusCode)
        }
        
        let responseData = data
        
        do {
            let json = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any]
            // save user credentials
            let responseUser = User(username: username, password: password)
            saveToKeychain(user: responseUser)
            
            return true
        } catch {
            throw AuthentiactionError.jsonParsingError
        }
    }
    
    
    func saveToKeychain(user: User) {
        self.user = user
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(user) {
            let keychain = Keychain(service: "com.finki.cloudgarden")
            keychain[data: "authInfo"] = encoded
        }
    }
    
    func logIn(username: String, password: String) async throws -> Bool {
        
        //        print("loading... LOGIN")
        //
        //        let parameters: [String: String] = [
        //            "username": username,
        //            "password": password
        //        ]
        //
        //        print(parameters)
        //
        //        AF
        //            .request(
        //                "https://cloudplant.azurewebsites.net/user/getuserbyusername",
        //                method: .get,
        //                parameters: parameters
        //            )
        //            .validate()
        //            .responseDecodable(of: UserResponse.self) { [weak self] dataResponse in
        //                guard let self = self else { return }
        //                //                MBProgressHUD.hide(for: self.view, animated: true)
        //                switch dataResponse.result {
        //                case .success(_):
        //                    let responseUser = User(username: username, password: password)
        //                    saveToKeychain(user: responseUser)
        //                    setupViews(user: self.user!)
        //                    print("SUCESSFUL LOGIN")
        //                case .failure(let error):
        //                    // show error message on screen
        //                    print(error)
        //                }
        //            }
        let url = URL(string: "https://cloudplant.azurewebsites.net/authentication/signin")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["username": username, "password": password]
        
        guard let bodyData = try? JSONSerialization.data(withJSONObject: body) else {
            throw AuthentiactionError.serializationError
        }
        
        request.httpBody = bodyData
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw AuthentiactionError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw AuthentiactionError.httpError(statusCode: httpResponse.statusCode)
        }
        
        let responseData = data
        
        do {
            let json = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any]
            // save user credentials
            let responseUser = User(username: username, password: password)
            saveToKeychain(user: responseUser)
            print("SUCESSFUL LOGIN")
            return true
        } catch {
            throw AuthentiactionError.jsonParsingError
        }
    }
    
    func setupViews(user: User) {
        let deviceAndPlantModel = DeviceAndPlantModel(user: user)
        let userModel = UserModel(window: self.window)
        
        let view = HomeNavigationView(userModel: userModel, deviceAndPlantModel: deviceAndPlantModel).navigationBarBackButtonHidden(true).navigationBarHidden(true)
        window.rootViewController = UIHostingController(rootView: view)
        print(window.rootViewController as Any)
    }
    
    func navigateToHomeFromOnboarding(deviceAndPlantModel: DeviceAndPlantModel) {
        let deviceAndPlantModel = deviceAndPlantModel
        let userModel = UserModel(window: self.window)
        
        let view = HomeNavigationView(userModel: userModel, deviceAndPlantModel: deviceAndPlantModel).navigationBarBackButtonHidden(true).navigationBarHidden(true)
        window.rootViewController = UIHostingController(rootView: view)
        print(window.rootViewController as Any)
    }
}
