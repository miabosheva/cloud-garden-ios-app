import SwiftUI
import NotificationBannerSwift
import _MapKit_SwiftUI
import CoreLocation

struct WeatherView: View {
    
    @StateObject private var locationManager = LocationManager()
    @Binding var goToMap: Bool
    
    var body: some View {
        MapView(longitude: Double(locationManager.location?.coordinate.longitude ?? 0.0), latitude: Double(locationManager.location?.coordinate.latitude ?? 0.0))
                    .edgesIgnoringSafeArea(.all)
        
        VStack(alignment: .leading) {
            
            Text("Current Statistics for")
                .foregroundColor(.secondary)
                .padding(.top, 8)
            
            Text("\(locationManager.city), \(locationManager.country)")
                .font(.title2)
                .foregroundColor(.black)
                .padding(.bottom, 8)
            
            VStack(alignment: .leading, spacing: 8) {
                // MARK: - Temperature
                VStack {
                    HStack {
                        Text("Temperature:")
                            .font(.headline)
                        Spacer()
                        if let temp = locationManager.weather?.temp {
                            Text("\(Int(temp))ºC")
                                .font(.headline)
                        } else {
                            Text("N/A")
                                .font(.headline)
                        }
                    }
                    if let temp = locationManager.weather?.temp {
                        HStack {
                            Text("Low")
                            ProgressView(value: normalizeValue(temp, minValue: -10.0, maxValue: 50.0))
                                .tint(.customLimeGreen)
                            Text("High")
                        }
                    }
                }
                .padding(.vertical, 8)
                
                Divider()
                
                // MARK: - Precipitation
                VStack {
                    HStack {
                        Text("Precipitation:")
                            .font(.headline)
                        Spacer()
                        if let precip = locationManager.weather?.precip {
                            Text("\(Int(precip))mm")
                                .font(.headline)
                        } else {
                            Text("N/A")
                                .font(.headline)
                        }
                    }
                    if let precip = locationManager.weather?.precip {
                        HStack {
                            Text("Low")
                            ProgressView(value: normalizeValue(precip, minValue: 0.0, maxValue: 50.0))
                                .tint(.customLimeGreen)
                            Text("High")
                        }
                    }
                }
                .padding(.vertical, 8)
                
                Divider()
                
                // MARK: - Humidity
                VStack {
                    HStack {
                        Text("Humidity:")
                            .font(.headline)
                        Spacer()
                        if let humidity = locationManager.weather?.humidity {
                            Text("\(Int(humidity))%")
                                .font(.headline)
                        } else {
                            Text("N/A")
                                .font(.headline)
                        }
                    }
                    if let humidity = locationManager.weather?.humidity {
                        HStack {
                            Text("Low")
                            ProgressView(value: normalizeValue(humidity, minValue: 30.0, maxValue: 50.0))
                                .tint(.customLimeGreen)
                            Text("High")
                        }
                    }
                }
                .padding(.vertical, 8)
            }
        }
        .toolbar {
            ToolbarItem {
                Button("Close") {
                    self.goToMap.toggle()
                }
                .foregroundColor(.customLimeGreen)
                .bold()
            }
        }
        .padding(.horizontal, 16)
        .onAppear {
            locationManager.startUpdatingLocation()
        }
        
        Spacer()
    }
    
    private func normalizeValue(_ value: Double, minValue: Double, maxValue: Double) -> Double {
        return (value - minValue) / (maxValue - minValue)
    }
    
    private var region: MKCoordinateRegion {
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 34.011_286, longitude: -116.166_868),
            span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        )
    }
}

// MARK: - Map View
struct MapView: UIViewRepresentable {
    var longitude: CLLocationDegrees
    var latitude: CLLocationDegrees
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.showsUserLocation = true
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        uiView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        uiView.addAnnotation(annotation)
    }
}

// MARK: - Location Manager
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let geocoder = CLGeocoder()
    private let locationManager = CLLocationManager()
    
    @Published var city: String = "Unknown"
    @Published var country: String = "Unknown"
    @Published var location: CLLocation?
    @Published var weather: CurrentConditions?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func fetchCity(for location: CLLocation) {
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                print("Error in reverse geocoding: \(error.localizedDescription)")
                return
            }
            
            guard let placemark = placemarks?.first else {
                print("No placemarks found")
                return
            }
            
            if let city = placemark.locality {
                DispatchQueue.main.async {
                    self.city = city
                }
            }
            
            if let country = placemark.country {
                DispatchQueue.main.async {
                    self.country = country
                }
            }
            
            if let location = placemark.location {
                DispatchQueue.main.async {
                    self.location = location
                }
            }
            Task {
                do {
                    self.weather = try await WeatherModel.getForecastForCoordinates(city: self.city)
                } catch {
                    print(error)
                }
            }
        }
    }
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            fetchCity(for: location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed with error: \(error.localizedDescription)")
    }
}

