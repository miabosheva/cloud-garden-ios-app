import Foundation
import UIKit

class DeviceAndPlantModel: ObservableObject {
    
    private weak var window: UIWindow!
    public var user: User
    public var devices: [Device] = []
    public var plants: [Plant] = []
    
    init(user: User){
        self.user = user
    }
    
    // MARK: - Helper methods - Device
    
    func changeDeviceName(title: String) {
        return
    }
    
    func addNewDeviceToUser(deviceId: String) async throws -> Bool {
        
        guard var urlComponents = URLComponents(string: "https://cloudplant.azurewebsites.net/device/createdevice") else {
            throw URLError(.badURL)
        }
        urlComponents.queryItems = [
            URLQueryItem(name: "code", value: deviceId)
        ]
        guard let url = urlComponents.url else {
            throw URLError(.badURL)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let decoder = JSONDecoder()
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw URLError(.badServerResponse)
            }
            guard (200...299).contains(httpResponse.statusCode) else {
                throw URLError(.unknown)
            }
            let deviceResponse = try decoder.decode(Device.self, from: data)
            print(deviceResponse.deviceId)
            let _ = try await addDeviceToUserRequest(deviceId: String(deviceResponse.deviceId))
        } catch {
            print(error)
            return false
        }
        return true
    }
    
    func addDeviceToUserRequest(deviceId: String) async throws -> () {
        guard var urlComponents = URLComponents(string: "https://cloudplant.azurewebsites.net/Device/AddUserToDevice") else {
            throw URLError(.badURL)
        }
        let username = user.username
        urlComponents.queryItems = [
            URLQueryItem(name: "deviceId", value: deviceId),
            URLQueryItem(name: "username", value: username)
        ]
        guard let url = urlComponents.url else {
            throw URLError(.badURL)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        guard (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.unknown)
        }
    }
    
    func getDevicesByUsernameRequest() async throws -> [Device] {
        guard var urlComponents = URLComponents(string: "https://cloudplant.azurewebsites.net/User/GetDevices") else {
            throw URLError(.badURL)
        }
        let username = user.username
        urlComponents.queryItems = [
            URLQueryItem(name: "username", value: username)
        ]
        guard let url = urlComponents.url else {
            throw URLError(.badURL)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let decoder = JSONDecoder()
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw URLError(.badServerResponse)
            }
            guard (200...299).contains(httpResponse.statusCode) else {
                throw URLError(.unknown)
            }
            let deviceResponse = try decoder.decode([Device].self, from: data)
            print(deviceResponse)
            return deviceResponse
        } catch {
            print(error)
            return []
        }
    }
    
    func deleteDevice(deviceId: Int) async throws -> Bool {
        // TODO: -
        return true
    }
    
    func getPlantCount(deviceId: Int) -> Optional<Int> {
        // TODO:
        return 0
    }
    
    // MARK: - Helper Methods - Plant
    
    func addPlant(deviceId: Int){
        return
    }
    
    func getAllPlantsByUsername(username: String) async throws -> [Plant] {
        // TODO: - implement function when its done on backend
        if self.plants.count > 0 {
            // do an api call
            self.plants = []
        }
        return self.plants
    }
    
    func deletePlant(plantId: Int) async throws -> Bool {
        guard var urlComponents = URLComponents(string: "https://cloudplant.azurewebsites.net/Plant") else {
            throw URLError(.badURL)
        }
        urlComponents.queryItems = [
            URLQueryItem(name: "id", value: String(plantId))
        ]
        guard let url = urlComponents.url else {
            throw URLError(.badURL)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw URLError(.badServerResponse)
            }
            guard (200...299).contains(httpResponse.statusCode) else {
                throw URLError(.unknown)
            }
        } catch {
            print(error)
            return false
        }
        return true
    }
}
