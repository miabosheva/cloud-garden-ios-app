import Foundation
import SwiftUI
import UIKit

class DeviceAndPlantModel: ObservableObject {
    
    // MARK: - Properties
    private weak var window: UIWindow!
    @Published public var user: User
    @Published public var devices: [Device] = []
    @Published public var plants: [Plant] = []
    
    // MARK: - Init
    init(user: User){
        self.user = user
    }
    
    // MARK: - Device Methods
    func addUserToDevice(code: String, title: String) async throws {
        guard let urlComponents = URLComponents(string: "https://ictfinal.azurewebsites.net/Device") else {
            throw URLError(.badURL)
        }
        guard let url = urlComponents.url else {
            throw URLError(.badURL)
        }
        let body : [String: Any] = [
            "code": code,
            "name": title,
            "username": self.user.username
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: body)
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
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
    }
    
    func getDevicesByUsername() async throws {
        guard var urlComponents = URLComponents(string: "https://ictfinal.azurewebsites.net/User/GetDevices") else {
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
        } catch {
            print(error)
            throw URLError(.unknown)
        }
    }
    
    func deleteDevice(deviceId: Int) async throws {
        guard var urlComponents = URLComponents(string: "https://ictfinal.azurewebsites.net/Device") else {
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
            throw URLError(.unknown)
        }
    }
    
    //     MARK: - Plant Methods
    func addPlant(title: String, deviceId: Int, plantTypeId: Int) async throws -> Bool {
        guard let urlComponents = URLComponents(string: "https://ictfinal.azurewebsites.net/Plant") else {
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
    
    func getAllPlantsByUsername(username: String) async throws {
        guard var urlComponents = URLComponents(string: "https://ictfinal.azurewebsites.net/User/GetPlants") else {
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
        } catch {
            print(error)
            throw URLError(.unknown)
        }
    }
    
    func deletePlant(plantId: Int) async throws -> Bool {
        guard var urlComponents = URLComponents(string: "https://ictfinal.azurewebsites.net/Plant") else {
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
    
    func getPlantCount(deviceId: Int) -> Int {
        if self.plants.count != 0 {
            return self.plants.filter { $0.deviceId == deviceId }.count
        }
        return 0
    }
    
    func getTypes() async throws -> [PlantType] {
        guard let urlComponents = URLComponents(string: "https://ictfinal.azurewebsites.net/PlantType/GetAllPlantTypes") else {
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
    
    func getLastTenMeasurements(plantId: Int) async throws -> [MeasurementResponse] {
        guard var urlComponents = URLComponents(string: "https://ictfinal.azurewebsites.net/Plant/GetMeasurements") else {
            throw URLError(.badURL)
        }
        urlComponents.queryItems = [
            URLQueryItem(name: "id", value: String(plantId))
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
            let measurements = try decoder.decode([MeasurementResponse].self, from: data)
            return measurements
        } catch {
            print(error)
            return []
        }
    }
    
    func calculateAverage(of property: KeyPath<MeasurementResponse, Int>, in list: [MeasurementResponse]) -> Double {
        let total = list.reduce(0.0) { $0 + Double($1[keyPath: property]) }
        return total / Double(list.count)
    }
    
    func calculatePlantHealth(plantId: Int) async throws -> Double {
        
        let measurements = try await getLastTenMeasurements(plantId: plantId)
        
        let plant: Plant = self.plants.filter{$0.plantId == plantId}[0]
        
        let lightIntensityThreshold = Double(plant.thresholdValue1)
        let temperatureThreshold = Double(plant.thresholdValue2)
        let humidityThreshold = Double(plant.thresholdValue3)
        let moistureThreshold = Double(plant.thresholdValue4)
        
        //        // test values
        //        let lightIntensityThreshold = 5.0
        //        let temperatureThreshold = 4.0
        //        let humidityThreshold = 8.0
        //        let moistureThreshold = 8.0
        
        var plantHealth = 1.0
        
        let temperatureMeasurement = calculateAverage(of: \.temperatureMeasurement, in: measurements)
        let humidityMeasurement = calculateAverage(of: \.humidityMeasurement, in: measurements)
        let moistureMeasurement = calculateAverage(of: \.soilMeasurement, in: measurements)
        let lightMeasurement = calculateAverage(of: \.lightIntensity, in: measurements)
        
        // Factors that affect the plant health calculated here
        if temperatureMeasurement < temperatureThreshold {
            plantHealth *= 0.6
        }
        if humidityMeasurement < humidityThreshold {
            plantHealth *= 0.5
        }
        if moistureMeasurement < moistureThreshold {
            plantHealth *= 0.8
        }
        if lightMeasurement < lightIntensityThreshold {
            plantHealth *= 0.8
        }
        let index = self.plants.firstIndex(where: { $0.plantId == plantId })
        self.plants[index!].plantHealth = plantHealth
        return plantHealth
    }
    
    func setLastWateringEntry(plantId: Int, date: Date) async throws {
        // format example of date: 2024-05-18 20:18:03 +0000
        // format in backend: 2024-05-18 20:18:03
        guard var urlComponents = URLComponents(string: "https://ictfinal.azurewebsites.net/Plant/UpdateLastWatering") else {
            throw URLError(.badURL)
        }
        
        // Format date to string and into wanted format
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let formattedDate = dateFormatter.string(from: date)
        
        urlComponents.queryItems = [
            URLQueryItem(name: "plantId", value: String(plantId)),
            URLQueryItem(name: "lastWatering", value: formattedDate)
        ]
        
        guard let url = urlComponents.url else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        guard (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.unknown)
        }
    }
}
