struct WeatherResponse: Codable {
    let latitude: Double
    let longitude: Double
    let queryCost: Int
    let tzoffset: Int
    let address: String
    let timezone: String
    let resolvedAddress: String
    let days: [WeatherDay]
    let currentConditions: CurrentConditions
    
    enum CodingKeys: String, CodingKey {
        case latitude, longitude, queryCost, tzoffset, address, timezone, resolvedAddress, days
        case currentConditions = "currentConditions"
    }
}

struct WeatherDay: Codable {
    let humidity: Double
    let precip: Double
    let temp: Double
}

struct CurrentConditions: Codable {
    let humidity: Double
    let precip: Double
    let temp: Double
}
