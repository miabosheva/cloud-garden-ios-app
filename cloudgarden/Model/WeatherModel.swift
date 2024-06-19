import Foundation

class WeatherModel {
    // Code has been copied from official OpenMeteo docs
    static func getForecastForCoordinates(city: String) async throws -> CurrentConditions {
        
        guard let url = URL(string: "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/\(city)/today?unitGroup=metric&elements=temp%2Chumidity%2Cprecip&include=current&key=U6UJ4EK46R89GFMMEN2DER4FA&contentType=json") else {
            throw URLError(.badURL)
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw URLError(.badServerResponse)
            }
            guard (200...299).contains(httpResponse.statusCode) else {
                throw URLError(.unknown)
            }
            
            let decoder = JSONDecoder()
            let weatherResponse = try decoder.decode(WeatherResponse.self, from: data)
            return weatherResponse.currentConditions
        } catch {
            print(error)
            throw URLError(.unknown)
        }
    }
}
