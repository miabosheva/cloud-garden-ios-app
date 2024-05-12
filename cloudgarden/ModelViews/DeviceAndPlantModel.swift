import Foundation
import UIKit

class DeviceAndPlantModel: ObservableObject {
    
    // MARK: - Properties
    
    private weak var window: UIWindow!
    public var user: User
    public var devices: [Device] = []
    public var plants: [Plant] = []
    
    // MARK: - Init
    
    init(user: User){
        self.user = user
    }
    
    // MARK: - Device Methods
    
    func changeDeviceName(title: String) {
        return
    }
    
    func addUserToDevice(code: String, title: String) async throws -> () {
        guard var urlComponents = URLComponents(string: "https://cloudplant.azurewebsites.net/Device/AddUserToDevice") else {
            throw URLError(.badURL)
        }
        let username = user.username
        urlComponents.queryItems = [
            URLQueryItem(name: "code", value: code),
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
            self.devices = deviceResponse
            return self.devices
        } catch {
            print(error)
            return []
        }
    }
    
    func deleteDevice(deviceId: Int) async throws -> Bool {
        guard var urlComponents = URLComponents(string: "https://cloudplant.azurewebsites.net/Device") else {
            throw URLError(.badURL)
        }
        urlComponents.queryItems = [
            URLQueryItem(name: "id", value: String(deviceId))
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
    
//     MARK: - Plant Methods
    func addPlant(title: String, deviceId: Int, plantTypeId: Int) async throws -> Bool {
        guard let urlComponents = URLComponents(string: "https://cloudplant.azurewebsites.net/Plant") else {
            throw URLError(.badURL)
        }
        guard let url = urlComponents.url else {
            throw URLError(.badURL)
        }
        let body : [String: Any] = [
            "deviceId": deviceId,
            "title": title,
            "plantTypeId": plantTypeId
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: body)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("\(String(describing: jsonData?.count))", forHTTPHeaderField: "Content-Length")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        guard (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.unknown)
        }
        return true
    }
    
    func getAllPlantsByUsername(username: String) async throws -> [Plant] {
        guard var urlComponents = URLComponents(string: "https://cloudplant.azurewebsites.net/User/GetPlants") else {
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
            let plantsResponse = try decoder.decode([Plant].self, from: data)
            self.plants = plantsResponse
            return self.plants
        } catch {
            print(error)
            return []
        }
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
    
    func getPlantCount(deviceId: Int) -> Optional<Int> {
        if self.plants.count != 0 {
            return self.plants.filter { $0.deviceId == deviceId }.count
        }
        return 0
    }
    
    func getTypes() async throws -> [PlantType] {
        guard let urlComponents = URLComponents(string: "https://cloudplant.azurewebsites.net/PlantType/GetAllPlantTypes") else {
            throw URLError(.badURL)
        }
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
            let plantTypes = try decoder.decode([PlantType].self, from: data)
            return plantTypes
        } catch {
            print(error)
            return []
        }
    }
}
