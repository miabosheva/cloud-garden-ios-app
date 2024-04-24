import Foundation

@Observable 
class ModelData {
    var plants: [Plant] = load("plants.json")
    var devices: [Device] = load("devices.json")
    var users: [User] = load("users.json")
}

func load<Plant: Decodable>(_ filename: String) -> Plant {
    let data: Data
    
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
    else {
        fatalError("Could not find \(filename) in main bundle.")
    }
    
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldnt load \(filename) from main bundle: \n\(error)")
    }
    
    do {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        return try decoder.decode(Plant.self, from: data)
    } catch {
        fatalError("Couldnt parse \(filename) as \(Plant.self): \n\(error)")
    }
}
