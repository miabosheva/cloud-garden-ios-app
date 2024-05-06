import Foundation
import SwiftUI
import UIKit
import KeychainAccess
import ProgressHUD

enum AuthentiactionError: Error {
    case serializationError
    case invalidResponse
    case httpError(statusCode: Int)
    case noData
    case jsonParsingError
}

class UserModel: ObservableObject {
    
    // MARK: - Properties
    private var modelData: ModelData = ModelData()
    private weak var window: UIWindow!
    public var user: User?
    
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
    
    func changePasswordForUser(newPassword: String) {
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
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw AuthentiactionError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw AuthentiactionError.httpError(statusCode: httpResponse.statusCode)
        }
        
        let responseUser = User(username: username, password: password)
        saveToKeychain(user: responseUser)
        
        return true
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
        
        let url = URL(string: "https://cloudplant.azurewebsites.net/authentication/signin")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["username": username, "password": password]
        
        guard let bodyData = try? JSONSerialization.data(withJSONObject: body) else {
            throw AuthentiactionError.serializationError
        }
        
        request.httpBody = bodyData
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw AuthentiactionError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw AuthentiactionError.httpError(statusCode: httpResponse.statusCode)
        }
        
        let responseUser = User(username: username, password: password)
        saveToKeychain(user: responseUser)
        return true
    }
    
    func setupViews(user: User) {
        let deviceAndPlantModel = DeviceAndPlantModel(user: user)
        
        let view = HomeNavigationView(userModel: self, deviceAndPlantModel: deviceAndPlantModel)
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
        window.rootViewController = UIHostingController(rootView: view)
    }
    
    func setupOnboardingView(user: User){
        let deviceAndPlantModel = DeviceAndPlantModel(user: user)
        
        let view = HomeNavigationView(userModel: self, deviceAndPlantModel: deviceAndPlantModel)
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
        window.rootViewController = UIHostingController(rootView: view)
        
        let onboardingView = OnboardingView(userModel: self, deviceAndPlantModel: deviceAndPlantModel)
        window.rootViewController?.present(UIHostingController(rootView: onboardingView), animated: true, completion: nil)
    }
    
    func navigateToHomeFromOnboarding(deviceAndPlantModel: DeviceAndPlantModel) {
        let deviceAndPlantModel = deviceAndPlantModel
        let userModel = UserModel(window: self.window)
        
        let view = HomeNavigationView(userModel: userModel, deviceAndPlantModel: deviceAndPlantModel).navigationBarBackButtonHidden(true).navigationBarHidden(true)
        window.rootViewController = UIHostingController(rootView: view)
    }
    
    func dismissView() {
        guard let presentingViewController = UIApplication.shared.windows.first?.rootViewController else {
            return
        }
        presentingViewController.dismiss(animated: true, completion: nil)
    }
}
